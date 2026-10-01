#!/usr/bin/env python3
"""
Show unmatched chunks: the English source next to the German bytes
(disassembled as code, or as hex with decoded text).

The German range of a run of unmatched chunks is taken from the end of the
previous matched chunk to the start of the next matched one.

Usage: tools/de/show.py FILE [-d] [-l LINE]
	-d   show German bytes as data (hex + text) instead of code
"""

import argparse
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(__file__))
from rgbobj import load_sym_addresses, rom_offset
from sm83 import disasm
from textlib import load_charmap

BANK = 0x4000


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('file')
	ap.add_argument('-d', '--data', action='store_true')
	ap.add_argument('-l', '--line', type=int)
	ap.add_argument('--max', type=int, default=0x200)
	args = ap.parse_args()

	rom = open('baserom.gbc', 'rb').read()
	built = open('pokecrystal-de.gbc', 'rb').read()
	de = json.load(open('de_syms.json'))
	built_syms = load_sym_addresses('pokecrystal-de.sym')
	decode, _ = load_charmap()
	rev = defaultdict(list)
	for n, e in de.items():
		rev[rom_offset(e['bank'], e['addr'])].append(n)
	ram = defaultdict(list)
	for n, (b, a) in built_syms.items():
		if a >= 0x8000:
			ram[a].append(n)

	items = [it for it in json.load(open('de_unmatched.json')) if it['file'] == args.file]
	if args.line:
		items = [it for it in items if it['line'] and it['line'] <= args.line] [-1:]
	src = open(args.file, encoding='utf-8').read().split('\n')

	# group consecutive unmatched chunks sharing the same German range
	groups = []
	for it in items:
		key = (it['de_prev_end'], it['de_next'])
		if groups and groups[-1][0] == key and key != (None, None):
			groups[-1][1].append(it)
		else:
			groups.append((key, [it]))

	for (lo, hi), its in groups:
		first, last = its[0], its[-1]
		names = ', '.join(n for it in its for n in it['names'][:1])
		print('=' * 100)
		print(f'{args.file}:{first["line"]}  {names}  (English {sum(i["size"] for i in its)} bytes)')
		# English source: from the first chunk's line to the line of the next matched label
		start = (first['line'] or 1) - 1
		end = start + 1
		nxt = last['next_names'][0] if last['next_names'] else None
		while end < len(src) and end - start < 200:
			l = src[end]
			if nxt and (l.startswith(nxt.split('.')[-1] + ':') or l.startswith('.' + nxt.split('.')[-1] + ':')):
				break
			end += 1
		print('--- English source')
		for l in src[start:end]:
			print('    ' + l)
		if lo is None or hi is None or not 0 <= hi - lo <= args.max:
			print(f'--- German range unknown ({lo!r}..{hi!r})')
			continue
		bank = lo // BANK
		pc0 = lo if bank == 0 else BANK + lo % BANK

		def name(a):
			if a >= 0x8000:
				return ram[a][0] if ram.get(a) else None
			off = a if a < BANK else rom_offset(bank, a)
			return rev[off][0] if rev.get(off) else None

		print(f'--- German {hi - lo} bytes at {bank:02x}:{pc0:04x}')
		if args.data:
			for p in range(lo, hi, 16):
				chunk = rom[p:min(p + 16, hi)]
				txt = ''.join(decode.get(b, '.') if len(decode.get(b, '..')) == 1 else '~' for b in chunk)
				print(f'    {p - lo:04x}  {chunk.hex(" "):48s}  {txt}')
		else:
			for off, pc, text, raw in disasm(rom, lo, hi, pc0, name):
				label = ''
				if rev.get(off):
					label = rev[off][0] + ':'
				if label:
					print(f'  {label}')
				print(f'\t{text:40s} ; {pc:04x}: {raw.hex(" ")}')


if __name__ == '__main__':
	main()
