#!/usr/bin/env python3
"""
Summarize unmatched chunks (from de_unmatched.json, written by locate.py).

Usage:
	tools/de/todo.py            # files ranked by unmatched bytes
	tools/de/todo.py FILE       # unmatched chunks in FILE
"""

import json
import sys
from collections import Counter

items = json.load(open('de_unmatched.json'))
if len(sys.argv) > 1:
	for it in items:
		if it['file'] == sys.argv[1]:
			guess = f"{it['de_guess']:#x}" if it['de_guess'] is not None else '-'
			print(f"{it['file']}:{it['line']}  {it['size']:5d}  de~{guess}  {','.join(it['names']) or '(section start)'}")
	sys.exit()

size = Counter()
count = Counter()
for it in items:
	size[it['file']] += it['size']
	count[it['file']] += 1
print(f'{sum(size.values())} unmatched bytes in {len(items)} chunks')
for f, v in size.most_common(60):
	print(f'{v:7d} {count[f]:5d}  {f}')
