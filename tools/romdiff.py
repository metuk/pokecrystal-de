#!/usr/bin/env python3
"""
Compare the built ROM against baserom.gbc and report where they differ,
resolved to sections (from the .map file) and labels (from the .sym file).

Usage:
	tools/romdiff.py                 # per-bank match summary + first differences
	tools/romdiff.py -b 0x0a         # only bank $0a
	tools/romdiff.py -n 50           # list up to 50 differing ranges
	tools/romdiff.py -l LabelName    # hexdump of a label in both ROMs
	tools/romdiff.py -s              # per-section match list (non-matching only)
"""

import argparse
import bisect
import re
import sys

BANK_SIZE = 0x4000


def rom_offset(bank, addr):
	return addr if bank == 0 else bank * BANK_SIZE + (addr - BANK_SIZE)


def load_syms(path):
	syms = []
	with open(path) as f:
		for line in f:
			m = re.match(r'([0-9a-f]{2}):([0-9a-f]{4}) (\S+)', line, re.I)
			if m:
				bank, addr = int(m[1], 16), int(m[2], 16)
				if addr < 0x8000:
					syms.append((rom_offset(bank, addr), m[3]))
	syms.sort()
	return syms


def load_sections(path):
	sections = []
	bank = None
	with open(path) as f:
		for line in f:
			m = re.match(r'(ROM0|ROMX) bank #(\d+):', line)
			if m:
				bank = int(m[2])
				continue
			if re.match(r'\S', line):
				bank = None
				continue
			m = re.match(r'\tSECTION: \$([0-9a-f]{4})(?:-\$([0-9a-f]{4}))? \(\$[0-9a-f]+ bytes?\) \["(.*)"\]', line, re.I)
			if m and bank is not None and m[2]:
				start, end = int(m[1], 16), int(m[2], 16)
				sections.append((rom_offset(bank, start), rom_offset(bank, end) + 1, m[3]))
	sections.sort()
	return sections


def find_label(syms, offset):
	i = bisect.bisect_right(syms, (offset, '￿')) - 1
	if i < 0:
		return '?'
	base, name = syms[i]
	return name if base == offset else f'{name}+{offset - base:#x}'


def find_section(sections, offset):
	i = bisect.bisect_right(sections, (offset, float('inf'), '')) - 1
	if i >= 0 and sections[i][0] <= offset < sections[i][1]:
		return sections[i][2]
	return '(empty/padding)'


def diff_ranges(a, b, lo, hi, merge=8):
	ranges = []
	start = None
	last = None
	for i in range(lo, hi):
		if a[i] != b[i]:
			if start is None:
				start = i
			elif i - last > merge:
				ranges.append((start, last + 1))
				start = i
			last = i
	if start is not None:
		ranges.append((start, last + 1))
	return ranges


def fmt_addr(offset):
	bank = offset // BANK_SIZE
	addr = offset if bank == 0 else BANK_SIZE + offset % BANK_SIZE
	return f'{bank:02x}:{addr:04x}'


def main():
	ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
	ap.add_argument('-r', '--rom', default='pokecrystal-de.gbc')
	ap.add_argument('--baserom', default='baserom.gbc')
	ap.add_argument('-b', '--bank', type=lambda x: int(x, 0))
	ap.add_argument('-n', '--num', type=int, default=20)
	ap.add_argument('-l', '--label')
	ap.add_argument('-s', '--sections', action='store_true')
	args = ap.parse_args()

	built = open(args.rom, 'rb').read()
	base = open(args.baserom, 'rb').read()
	stem = args.rom.rsplit('.', 1)[0]
	syms = load_syms(stem + '.sym')
	sections = load_sections(stem + '.map')
	size = min(len(built), len(base))

	if args.label:
		names = {n: o for o, n in syms}
		if args.label not in names:
			sys.exit(f'Label {args.label} not found')
		o = names[args.label]
		nxt = next((s for s, _ in syms if s > o), o + 0x40)
		end = min(nxt, o + 0x100)
		print(f'{args.label} @ {fmt_addr(o)} ({end - o:#x} bytes)')
		for i in range(o, end, 16):
			x, y = built[i:min(i + 16, end)], base[i:min(i + 16, end)]
			mark = ' ' if x == y else '*'
			print(f'{mark} {fmt_addr(i)}  built {x.hex(" ")}')
			if x != y:
				print(f'           base  {y.hex(" ")}')
		return

	banks = [args.bank] if args.bank is not None else range(size // BANK_SIZE)

	if args.sections:
		for start, end, name in sections:
			if args.bank is not None and start // BANK_SIZE != args.bank:
				continue
			same = sum(built[i] == base[i] for i in range(start, end))
			if same != end - start:
				print(f'{fmt_addr(start)} {same * 100 // (end - start):3d}%  {name}')
		return

	total_same = 0
	lines = []
	for bank in banks:
		lo, hi = bank * BANK_SIZE, (bank + 1) * BANK_SIZE
		same = sum(x == y for x, y in zip(built[lo:hi], base[lo:hi]))
		total_same += same
		lines.append(f'{bank:02x}:{"OK " if same == BANK_SIZE else f"{same * 100 // BANK_SIZE:2d}%"}')
	for i in range(0, len(lines), 8):
		print('  '.join(lines[i:i + 8]))
	checked = len(banks) * BANK_SIZE
	print(f'\n{total_same}/{checked} bytes match ({total_same * 100 / checked:.2f}%)')
	if len(built) != len(base):
		print(f'Size mismatch: built {len(built):#x}, base {len(base):#x}')

	shown = 0
	for bank in banks:
		for start, end in diff_ranges(built, base, bank * BANK_SIZE, (bank + 1) * BANK_SIZE):
			if shown == 0:
				print('\nFirst differences:')
			if shown >= args.num:
				return
			shown += 1
			print(f'{fmt_addr(start)} len {end - start:#06x}  [{find_section(sections, start)}] {find_label(syms, start)}')
			print(f'    built {built[start:start + 12].hex(" ")}')
			print(f'    base  {base[start:start + 12].hex(" ")}')


if __name__ == '__main__':
	main()
