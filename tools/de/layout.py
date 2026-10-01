#!/usr/bin/env python3
"""
Compare where each section starts in the build vs. in baserom.gbc
(from the located chunks in de_syms.json), bank by bank.

Usage: tools/de/layout.py [-a]    (-a: also list sections that are in place)
"""

import argparse
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(__file__))
import locate
from rgbobj import load_objects, load_sym_addresses, place_sections, rom_offset

BANK = 0x4000


def fmt(off):
	if off is None:
		return '   ?   '
	b = off // BANK
	return f'{b:02x}:{off if b == 0 else BANK + off % BANK:04x}'


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('-a', '--all', action='store_true')
	args = ap.parse_args()

	de = json.load(open('de_syms.json'))
	objects = load_objects(locate.rom_objects())
	place_sections(objects, load_sym_addresses('pokecrystal-de.sym'), locate.map_section_offsets('pokecrystal-de.map'))

	rows = defaultdict(list)
	for obj in objects:
		for sect in obj.sections:
			if sect.rom_offset is None or not sect.size:
				continue
			# DE start: from the first symbols whose German address is known (not a guess)
			votes = defaultdict(int)
			for sym in sorted(sect.symbols, key=lambda s: s.value):
				e = de.get(sym.name)
				if e and e['src'] not in ('gap', 'ptr', 'far'):
					votes[rom_offset(e['bank'], e['addr']) - sym.value] += 1
			de_start = max(votes, key=votes.get) if votes else None
			consistent = len(votes) <= 1
			rows[sect.rom_offset // BANK].append((sect.rom_offset, de_start, sect.size, sect.name, consistent))

	for bank in sorted(rows):
		lines = []
		for built, de_start, size, name, consistent in sorted(rows[bank]):
			ok = built == de_start
			if ok and consistent and not args.all:
				continue
			flag = 'ok ' if ok else ('MOV' if de_start is not None else ' ? ')
			if not consistent:
				flag += ' (internal shifts)'
			lines.append(f'  {fmt(built)} -> {fmt(de_start)}  {size:#06x}  {flag}  {name}')
		if lines:
			print(f'bank ${bank:02x}:')
			print('\n'.join(lines))


if __name__ == '__main__':
	main()
