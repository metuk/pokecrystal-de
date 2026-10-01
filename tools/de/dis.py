#!/usr/bin/env python3
"""
Disassemble baserom.gbc between two addresses (or from a German label).

Usage: tools/de/dis.py BANK:ADDR [LENGTH]   e.g. tools/de/dis.py 00:1080 0x80
       tools/de/dis.py LABEL [LENGTH]
"""

import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(__file__))
from rgbobj import load_sym_addresses, rom_offset
from sm83 import disasm

rom = open('baserom.gbc', 'rb').read()
de = json.load(open('de_syms.json'))
built = load_sym_addresses('pokecrystal-de.sym')
arg = sys.argv[1]
if ':' in arg:
	b, a = arg.split(':')
	bank, addr = int(b, 16), int(a, 16)
else:
	bank, addr = de[arg]['bank'], de[arg]['addr']
length = int(sys.argv[2], 0) if len(sys.argv) > 2 else 0x40
rev = defaultdict(list)
for n, e in de.items():
	rev[rom_offset(e['bank'], e['addr'])].append(n)
ram = defaultdict(list)
for n, (b, a) in built.items():
	if a >= 0x8000:
		ram[a].append(n)


def name(a):
	if a >= 0x8000:
		return ram[a][0] if ram.get(a) else None
	off = a if a < 0x4000 else rom_offset(bank, a)
	return rev[off][0] if rev.get(off) else None


start = rom_offset(bank, addr)
for off, pc, text, raw in disasm(rom, start, start + length, addr, name):
	if rev.get(off):
		print(f'{rev[off][0]}:')
	print(f'\t{text:40s} ; {pc:04x}: {raw.hex(" ")}')
