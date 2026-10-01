#!/usr/bin/env python3
"""
Diff the build's code against the German code for unmatched chunks of a file:
both are disassembled (addresses and pointer operands normalized) and
compared line by line.

Usage: tools/de/cmp.py FILE [-c CONTEXT]
"""

import argparse
import difflib
import json
import os
import re
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(__file__))
from rgbobj import load_sym_addresses, rom_offset
from sm83 import disasm

BANK = 0x4000


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('file')
	ap.add_argument('-c', '--context', type=int, default=2)
	ap.add_argument('--max', type=int, default=0x400)
	args = ap.parse_args()

	rom = open('baserom.gbc', 'rb').read()
	built = open('pokecrystal-de.gbc', 'rb').read()
	de = json.load(open('de_syms.json'))
	bsyms = load_sym_addresses('pokecrystal-de.sym')
	brev = defaultdict(list)
	for n, (b, a) in bsyms.items():
		brev[(b, a)].append(n)
	drev = defaultdict(list)
	for n, e in de.items():
		drev[(e['bank'], e['addr'])].append(n)

	items = [it for it in json.load(open('de_unmatched.json')) if it['file'] == args.file]
	groups = []
	for it in items:
		key = (it['de_prev_end'], it['de_next'])
		if groups and groups[-1][0] == key and key != (None, None):
			groups[-1][1].append(it)
		else:
			groups.append((key, [it]))

	def lines(data, lo, hi, bank, rev):
		pc0 = lo if bank == 0 else BANK + lo % BANK

		def name(a):
			k = (0, a) if a < BANK else (bank, a) if a < 0x8000 else None
			if k is None:
				for n, (b, aa) in bsyms.items():
					pass
				return None
			return rev[k][0] if rev.get(k) else None

		out = []
		for off, pc, text, raw in disasm(data, lo, hi, pc0, name):
			lbl = rev.get((bank, pc) if pc >= BANK else (0, pc))
			if lbl:
				out.append(lbl[0].split('.')[-1] + ':')
			out.append('\t' + text)
		return out

	for (lo, hi), its in groups:
		names = ', '.join(it['names'][0] for it in its if it['names'])
		print('=' * 80)
		print(f'{args.file}:{its[0]["line"]}  {names}')
		b_lo = its[0]['built']
		b_hi = its[-1]['built'] + its[-1]['size']
		if lo is None:
			print('  German start unknown')
			continue
		if hi is None or not 0 <= hi - lo <= args.max:
			hi = lo + (b_hi - b_lo) + 0x20
			print(f'  German end unknown, showing {hi - lo} bytes')
		bb = b_lo // BANK
		db = lo // BANK
		en = lines(built, b_lo, b_hi, bb, brev)
		ge = lines(rom, lo, hi, db, drev)
		# raw hex numbers that are addresses differ between builds; keep them, labels mostly resolve
		for l in difflib.unified_diff(en, ge, 'build', 'german', n=args.context, lineterm=''):
			if l.startswith(('---', '+++')):
				continue
			print(l)


if __name__ == '__main__':
	main()
