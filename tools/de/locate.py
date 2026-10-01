#!/usr/bin/env python3
"""
Locate the built ROM's code/data in baserom.gbc and infer where every label
lives in the German ROM.

Each ROM section of the build is split at its labels into chunks. Every byte
that the linker patches (pointers, banks, jr offsets, ...) is a wildcard, so
a chunk whose code is unchanged matches the baserom regardless of shifted
addresses. Matched chunks give label addresses directly; the pointer bytes
read from the baserom inside matched chunks give the addresses of the labels
they reference (e.g. text that doesn't match because it was translated).

Output: de_syms.json (name -> {bank, addr, src}) and a coverage report.

Usage: tools/de/locate.py [-o de_syms.json] [-v]
"""

import argparse
import json
import os
import re
import sys
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(__file__))
from rgbobj import (ROM_TYPES, classify_patch, load_objects, load_sym_addresses,
	parse_rpn, place_sections, rom_offset)

BANK = 0x4000
MIN_SPEC = 12  # minimum number of non-wildcard bytes to search a chunk globally
WEAK_SPEC = 6  # chunks with fewer non-wildcard bytes are only placed when unambiguous


def to_bank_addr(off):
	bank = off // BANK
	return bank, off if bank == 0 else BANK + off % BANK


def rom_objects():
	mk = open('Makefile').read()
	m = re.search(r'rom_obj := \\\n((?:\t.*\n)+)', mk)
	return [l.strip(' \t\\') for l in m[1].splitlines() if l.strip(' \t\\')]


def map_section_offsets(path):
	res = {}
	bank = None
	for line in open(path):
		m = re.match(r'(ROM0|ROMX) bank #(\d+):', line)
		if m:
			bank = int(m[2])
			continue
		if re.match(r'\S', line):
			bank = None
			continue
		m = re.match(r'\tSECTION: \$([0-9a-f]{4})(?:-\$[0-9a-f]{4})? \(.*\) \["(.*)"\]', line)
		if m and bank is not None:
			res.setdefault(m[2], rom_offset(bank, int(m[1], 16)))
	return res


class Chunk:
	__slots__ = ('obj', 'sect', 'start', 'end', 'names', 'mask', 'built_off', 'de_off', 'src', 'index', 'file')

	def __init__(self, obj, sect, start, end, names, mask, file=None):
		self.obj = obj
		self.sect = sect
		self.start = start
		self.end = end
		self.names = names
		self.mask = mask
		self.built_off = sect.rom_offset + start
		self.de_off = None
		self.src = None
		self.file = file

	@property
	def size(self):
		return self.end - self.start

	@property
	def data(self):
		return self.sect.data[self.start:self.end]

	def spec(self):
		return self.size - sum(self.mask)

	def pattern(self):
		parts = []
		for b, m in zip(self.data, self.mask):
			parts.append(b'.' if m else re.escape(bytes([b])))
		return re.compile(b''.join(parts), re.DOTALL)

	def matches_at(self, rom, off):
		if off < 0 or off + self.size > len(rom):
			return False
		d = self.data
		for i in range(self.size):
			if not self.mask[i] and rom[off + i] != d[i]:
				return False
		return True


def build_chunks(objects):
	chunks_by_sect = []
	for obj in objects:
		for sect in obj.sections:
			if sect.type not in ROM_TYPES or sect.rom_offset is None or not sect.size:
				continue
			mask = bytearray(sect.size)
			for p in sect.patches:
				for i in range(p.size):
					mask[p.offset + i] = 1
			bounds = defaultdict(list)
			bounds[0]
			files = {}
			for sym in sect.symbols:
				if 0 <= sym.value < sect.size:
					bounds[sym.value].append(sym.name)
					files.setdefault(sym.value, sym.file)
			starts = sorted(bounds)
			chunks = []
			for i, s in enumerate(starts):
				e = starts[i + 1] if i + 1 < len(starts) else sect.size
				c = Chunk(obj, sect, s, e, bounds[s], mask[s:e], files.get(s))
				chunks.append(c)
			for i, c in enumerate(chunks):
				c.index = i
			chunks_by_sect.append(chunks)
	return chunks_by_sect


def search(rom, pat, lo, hi, limit=2):
	found = []
	pos = lo
	while len(found) < limit:
		m = pat.search(rom, pos, hi)
		if not m:
			break
		found.append(m.start())
		pos = m.start() + 1
	return found


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('-o', '--output', default='de_syms.json')
	ap.add_argument('--rom', default='pokecrystal-de')
	ap.add_argument('--baserom', default='baserom.gbc')
	ap.add_argument('-v', '--verbose', action='store_true')
	args = ap.parse_args()

	base = open(args.baserom, 'rb').read()
	objects = load_objects(rom_objects())
	sym_addrs = load_sym_addresses(args.rom + '.sym')
	place_sections(objects, sym_addrs, map_section_offsets(args.rom + '.map'))
	sects = build_chunks(objects)
	all_chunks = [c for cs in sects for c in cs]

	# Pass 1: unique global matches of specific chunks (prefer the same bank)
	for c in all_chunks:
		if c.spec() < MIN_SPEC:
			continue
		pat = c.pattern()
		bank = c.built_off // BANK
		lo, hi = bank * BANK, (bank + 1) * BANK
		found = search(base, pat, lo, hi)
		if len(found) == 1:
			c.de_off, c.src = found[0], 'unique-bank'
			continue
		if found:
			continue
		found = search(base, pat, 0, len(base))
		if len(found) == 1:
			c.de_off, c.src = found[0], 'unique-rom'

	# Pass 2: sequential propagation within sections.
	# Specific chunks propagate from either neighbour; weak (short) chunks only
	# when the candidate positions from both neighbours agree (or only one exists).
	def candidates(cs, i, c):
		# Short chunks may only chain from one side within the same source file
		# (whole files may have moved); with both neighbours they must agree.
		prev = cs[i - 1] if i > 0 and cs[i - 1].de_off is not None and cs[i - 1].src != 'gap' else None
		nxt = cs[i + 1] if i + 1 < len(cs) and cs[i + 1].de_off is not None and cs[i + 1].src != 'gap' else None
		a = prev.de_off + prev.size if prev else None
		b = nxt.de_off - c.size if nxt else None
		if c.spec() >= WEAK_SPEC:
			return [x for x in (a, b) if x is not None]
		if a is not None and b is not None:
			return [a] if a == b else []
		if a is not None and prev.file == c.file:
			return [a]
		if b is not None and nxt.file == c.file:
			return [b]
		return []

	for weak_ok in (False, True):
		changed = True
		while changed:
			changed = False
			for cs in sects:
				for i, c in enumerate(cs):
					if c.de_off is not None:
						continue
					cands = candidates(cs, i, c)
					if not cands:
						continue
					weak = c.spec() < WEAK_SPEC
					if weak and not weak_ok:
						continue
					good = [off for off in cands if c.matches_at(base, off)]
					if not good:
						continue
					c.de_off, c.src = good[0], 'seq'
					changed = True

	# Pass 3: local search for short chunks between matched neighbours
	for cs in sects:
		for i, c in enumerate(cs):
			if c.de_off is not None or c.spec() < 4:
				continue
			prev = next((p for p in reversed(cs[:i]) if p.de_off is not None and p.src != 'gap'), None)
			nxt = next((n for n in cs[i + 1:] if n.de_off is not None and n.src != 'gap'), None)
			if not prev or not nxt:
				continue
			lo, hi = prev.de_off + prev.size, nxt.de_off
			if not 0 <= hi - lo <= 0x800:
				continue
			found = search(base, c.pattern(), lo, hi)
			if len(found) == 1:
				c.de_off, c.src = found[0], 'local'

	# Pass 4: an unmatched chunk right after a matched one starts where that one ends
	for cs in sects:
		for i, c in enumerate(cs):
			if c.de_off is None and i > 0 and cs[i - 1].de_off is not None and cs[i - 1].src != 'gap' \
					and cs[i - 1].file == c.file:
				c.de_off, c.src = cs[i - 1].de_off + cs[i - 1].size, 'gap'

	# Collect label addresses
	de = {}
	for c in all_chunks:
		if c.de_off is None:
			continue
		bank, addr = to_bank_addr(c.de_off)
		for n in c.names:
			de[n] = {'bank': bank, 'addr': addr, 'src': c.src}

	# Pointer votes from matched chunks
	built_rom_bank = {n: b for n, (b, a) in sym_addrs.items()}
	votes = defaultdict(Counter)
	bank_votes = defaultdict(Counter)
	for c in all_chunks:
		if c.de_off is None or c.src == 'gap':
			continue
		chunk_bank = c.de_off // BANK
		built_bank = c.built_off // BANK
		for p in c.sect.patches:
			if not c.start <= p.offset < c.end or p.type == 3:
				continue
			cl = classify_patch(parse_rpn(p.rpn, c.obj.symbols))
			if not cl:
				continue
			kind, name, addend = cl
			pos = c.de_off + p.offset - c.start
			if kind == 'bank':
				bank_votes[name][base[pos]] += 1
			elif kind == 'addr' and p.type == 1:
				v = base[pos] | base[pos + 1] << 8
				votes[name][(v - addend) & 0xffff, built_bank, chunk_bank] += 1

	# DE bank of each built section: located chunks, plus BANK() votes of its labels
	sym_sect = {}
	for obj in objects:
		for sect in obj.sections:
			for sym in sect.symbols:
				sym_sect[sym.name] = id(sect)
	sect_banks = defaultdict(Counter)
	for c in all_chunks:
		if c.de_off is not None and c.src != 'gap':
			sect_banks[id(c.sect)][c.de_off // BANK] += c.size
	for name, cnt in bank_votes.items():
		if name in sym_sect:
			sect_banks[sym_sect[name]][cnt.most_common(1)[0][0]] += 1000

	inferred = 0
	for name, cnt in votes.items():
		if name in de or name not in sym_addrs:
			continue
		sb, sa = sym_addrs[name]
		if sa >= 0x8000:
			continue
		(addr, built_bank, chunk_bank), _ = cnt.most_common(1)[0]
		if addr < 0x4000:
			bank = 0
		elif name in bank_votes:
			bank = bank_votes[name].most_common(1)[0][0]
		elif sb == built_bank:
			bank = chunk_bank
		elif sect_banks.get(sym_sect.get(name)):
			bank = sect_banks[sym_sect[name]].most_common(1)[0][0]
		else:
			continue
		de[name] = {'bank': bank, 'addr': addr, 'src': 'ptr'}
		inferred += 1

	json.dump(de, open(args.output, 'w'), indent=0, sort_keys=True)

	# Report
	srcs = Counter(c.src for c in all_chunks)
	covered = bytearray(len(base) // BANK)
	cov = defaultdict(int)
	for c in all_chunks:
		if c.de_off is not None and c.src != 'gap':
			cov[c.de_off // BANK] += c.size
	total_bytes = sum(c.size for c in all_chunks)
	matched_bytes = sum(c.size for c in all_chunks if c.de_off is not None and c.src != 'gap')
	print(f'chunks: {len(all_chunks)}  ' + '  '.join(f'{k}:{v}' for k, v in srcs.most_common()))
	print(f'matched bytes: {matched_bytes}/{total_bytes} ({matched_bytes * 100 / total_bytes:.1f}%)')
	print(f'labels located: {len(de)} ({inferred} from pointers)')
	lines = [f'{b:02x}:{min(cov[b] * 100 // BANK, 100):3d}%' for b in range(len(base) // BANK)]
	print('matched code/data per DE bank:')
	for i in range(0, len(lines), 8):
		print('  '.join(lines[i:i + 8]))


if __name__ == '__main__':
	main()
