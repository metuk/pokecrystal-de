#!/usr/bin/env python3
"""
Replace English text blocks in the source with the German text from baserom.gbc.

Requires de_syms.json from tools/de/locate.py (label -> German address).
A text block is a label followed by text macros (text, line, para, ...,
text_ram, text_far, ...) up to a terminator (done, prompt, text_end, text_asm).

Labels without a known German address that directly follow a decoded block
in the source are assumed to follow it in the ROM as well.

Usage: tools/de/retext.py [-n] [-v] [files...]
	-n  dry run (report only)
"""

import argparse
import glob
import json
import os
import re
import sys
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(__file__))
from textlib import TextError, decode_text, format_block, load_charmap
from rgbobj import load_sym_addresses, rom_offset

TEXT_MACROS = re.compile(r'\t(text|line|para|cont|next|done|prompt|text_\w+|sound_\w+)\b')
TERMINATORS = ('done', 'prompt', 'text_end', 'text_asm')
LABEL = re.compile(r'^(\.?[A-Za-z_][\w.]*)(::?)\s*(;.*)?$')


class Block:
	def __init__(self, path, name, label_line, first, last, lines):
		self.path = path
		self.name = name
		self.label_line = label_line
		self.first = first  # index of first macro line
		self.last = last  # index of last macro line (inclusive)
		self.lines = lines  # original macro lines (stripped)

	@property
	def terminated(self):
		return self.lines[-1].split()[0] in TERMINATORS


def parse_blocks(path):
	src = open(path, encoding='utf-8').read().split('\n')
	blocks = []
	scope = None
	i = 0
	order = []  # sequence of (kind, name) in file order, for adjacency
	while i < len(src):
		m = LABEL.match(src[i])
		if not m:
			if src[i].strip() and not src[i].strip().startswith(';'):
				order.append(('other', None))
			i += 1
			continue
		name = m[1]
		if name.startswith('.'):
			name = f'{scope}{name}'
		else:
			scope = name
		j = i + 1
		first = last = None
		macros = []
		while j < len(src):
			line = src[j]
			s = line.strip()
			if not s or s.startswith(';'):
				j += 1
				continue
			if TEXT_MACROS.match(line):
				if first is None:
					first = j
				last = j
				macros.append(s.split(';')[0].strip() if not s.startswith('text "') else s)
				j += 1
				if s.split()[0] in TERMINATORS:
					break
				continue
			break
		if macros:
			b = Block(path, name, i, first, last, macros)
			blocks.append(b)
			order.append(('text', b))
		else:
			order.append(('label', name))
		i = j if macros else i + 1
	return src, blocks, order


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('files', nargs='*')
	ap.add_argument('-n', '--dry-run', action='store_true')
	ap.add_argument('-v', '--verbose', action='store_true')
	ap.add_argument('--syms', default='de_syms.json')
	ap.add_argument('--rom', default='pokecrystal-de')
	args = ap.parse_args()

	files = args.files or sorted(set(glob.glob('**/*.asm', recursive=True)) - set(glob.glob('tools/**', recursive=True)) - set(glob.glob('audio/**', recursive=True)))
	base = open('baserom.gbc', 'rb').read()
	decode, _ = load_charmap()
	de = json.load(open(args.syms))
	built = load_sym_addresses(args.rom + '.sym')

	de_rev = defaultdict(list)
	for n, e in de.items():
		de_rev[(e['bank'], e['addr'])].append(n)
	ram_rev = defaultdict(list)
	for n, (b, a) in built.items():
		if a >= 0x8000:
			ram_rev[a].append(n)

	stats = Counter()
	problems = []

	for path in files:
		src, blocks, order = parse_blocks(path)
		if not blocks:
			continue
		replacements = {}
		next_guess = None
		for kind, item in order:
			if kind != 'text':
				next_guess = None
				continue
			b = item
			stats['blocks'] += 1
			e = de.get(b.name)
			if e:
				off = rom_offset(e['bank'], e['addr'])
				if next_guess is not None and next_guess != off:
					stats['adjacency_mismatch'] += 1
			elif next_guess is not None:
				off = next_guess
				stats['from_adjacency'] += 1
			else:
				stats['no_address'] += 1
				problems.append(f'{path}: {b.name}: no German address')
				next_guess = None
				continue
			if not b.terminated:
				stats['unterminated_source'] += 1
				problems.append(f'{path}: {b.name}: source block falls through, skipped')
				next_guess = None
				continue

			en_words = {}
			for l in b.lines:
				for w in re.findall(r'\b[wh][A-Z]\w*(?:\s*[+-]\s*\w+)?|\b[A-Z_][A-Z0-9_]+\b|\b_?[A-Za-z]\w*Text\w*\b|\b_\w+', l):
					en_words[w.strip()] = True

			def name_word(v):
				names = ram_rev.get(v, [])
				for n in names:
					if n in en_words:
						return n
				for n in names:
					if '.' not in n:
						return n
				return f'${v:04x}'

			def name_far(bank, addr):
				names = de_rev.get((bank, addr), [])
				for n in names:
					if n in en_words:
						return n
				for n in names:
					if '.' not in n:
						return n
				raise TextError(f'text_far target {bank:02x}:{addr:04x} unknown')

			try:
				lines, end = decode_text(base, off, decode, name_word, name_far)
			except TextError as ex:
				stats['decode_error'] += 1
				problems.append(f'{path}: {b.name}: {ex}')
				next_guess = None
				continue
			if lines[-1].split()[0] != b.lines[-1].split()[0]:
				stats['terminator_differs'] += 1
				problems.append(f'{path}: {b.name}: terminator {b.lines[-1].split()[0]} -> {lines[-1].split()[0]}')
			replacements[b.first] = (b.last, format_block(lines))
			stats['replaced'] += 1
			next_guess = end

		if replacements and not args.dry_run:
			out = []
			i = 0
			while i < len(src):
				if i in replacements:
					last, new = replacements[i]
					out += new
					i = last + 1
				else:
					out.append(src[i])
					i += 1
			open(path, 'w', encoding='utf-8').write('\n'.join(out))

	for k, v in stats.most_common():
		print(f'{k}: {v}')
	with open('retext_problems.txt', 'w') as f:
		f.write('\n'.join(problems) + '\n')
	print(f'{len(problems)} problems written to retext_problems.txt')


if __name__ == '__main__':
	main()
