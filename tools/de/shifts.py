#!/usr/bin/env python3
"""
List where label addresses start to differ between the build and baserom
(German addresses from de_syms.json), for one bank.

Usage: tools/de/shifts.py BANK
"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rgbobj import load_sym_addresses

bank = int(sys.argv[1], 16)
de = json.load(open('de_syms.json'))
built = load_sym_addresses('pokecrystal-de.sym')
rows = sorted((a, n) for n, (b, a) in built.items() if b == bank and a < 0x8000 and n in de
	and de[n]['bank'] == bank and de[n]['src'] not in ('gap', 'ptr', 'far'))
last = None
for a, n in rows:
	d = de[n]['addr'] - a
	if d != last:
		print(f'{a:04x} -> {de[n]["addr"]:04x}  shift {d:+d}  {n}')
		last = d
