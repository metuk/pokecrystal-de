#!/usr/bin/env python3
"""
Replace graphics (PNG sources of INCBIN'd .1bpp/.2bpp[.lz]) with the German
graphics from baserom.gbc, at the addresses in de_syms.json.

For .lz files the German stream is decompressed, the PNG is written, and the
compressor is run with the current gfx/lz.mk flags; if that doesn't reproduce
the German stream, other flag combinations are tried and the matching one is
reported (add it to gfx/lz.mk).

Usage: tools/de/regfx.py [-n] LABEL...
       tools/de/regfx.py --all      (all unmatched INCBIN graphics in de_unmatched.json)
"""

import argparse
import itertools
import json
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
from gbgfx import png_size, tiles_to_pixels, write_png
from lz import decompress
from rgbobj import rom_offset

MAKE = ['make', 'RGBDS=../rgbds-1.0.4/']
LZ_FLAG_SETS = [[]] + [list(c) for n in (1, 2) for c in itertools.combinations(
	['--prefer-alternate', '--odd-alternate', '--literal-only', '--iterate-only', '--skip-initial-byte',
	 '--no-lookback-3', '--long-32'], n)]
ALIGNS = [None, '0', '1', '2', '4']


def find_incbin(label):
	"""Find the INCBIN line right after `label` in the source."""
	out = subprocess.run(['grep', '-rn', '--include=*.asm', '-E', rf'^{re.escape(label.split(".")[-1] if "." in label else label)}:', '.'],
		capture_output=True, text=True).stdout
	for hit in out.splitlines():
		path, line, _ = hit.split(':', 2)
		src = open(path, encoding='utf-8').read().split('\n')
		for l in src[int(line) - 1:int(line) + 3]:
			m = re.search(r'INCBIN "([^"]+)"(.*)', l)
			if m:
				return path, m[1], m[2].strip()
	return None, None, None


def flags_for(target, makefile_text):
	"""RGBGFXFLAGS / tools/gfx flags for a target in the Makefile."""
	f = {}
	for m in re.finditer(rf'^{re.escape(target)}: (RGBGFXFLAGS|tools/gfx) \+= (.*)$', makefile_text, re.M):
		f[m[1]] = m[2]
	return f


def lzcompress(src, flags):
	r = subprocess.run(['tools/lzcompress'] + flags + ['--', src, '/dev/stdout'], capture_output=True)
	return r.stdout


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('labels', nargs='*')
	ap.add_argument('--all', action='store_true')
	ap.add_argument('-n', '--dry-run', action='store_true')
	args = ap.parse_args()

	rom = open('baserom.gbc', 'rb').read()
	de = json.load(open('de_syms.json'))
	mk = open('Makefile').read()
	labels = args.labels
	if args.all:
		labels = [it['names'][0] for it in json.load(open('de_unmatched.json')) if it['names']]

	for label in labels:
		e = de.get(label)
		path, incbin, extra = find_incbin(label)
		if not incbin:
			if not args.all:
				print(f'{label}: no INCBIN')
			continue
		if not e:
			print(f'{label}: {incbin}: no German address')
			continue
		if extra:
			print(f'{label}: {incbin}: INCBIN with range ({extra}), skipped')
			continue
		m = re.match(r'(.*)\.([12])bpp(\.lz)?$', incbin)
		if not m:
			bm = re.match(r'(.*\.(tilemap|attrmap|blk|bin))(\.lz)?$', incbin)
			if not bm or not os.path.exists(bm[1]):
				print(f'{label}: {incbin}: not handled, skipped')
				continue
			off = rom_offset(e['bank'], e['addr'])
			en_raw = open(bm[1], 'rb').read()
			if bm[3]:
				raw, clen = decompress(rom, off)
				de_lz = rom[off:off + clen]
			else:
				raw = rom[off:off + len(en_raw)]
			if raw == en_raw:
				print(f'{label}: {bm[1]} unchanged')
				continue
			if args.dry_run:
				print(f'{label}: would write {bm[1]} ({len(en_raw)} -> {len(raw)} bytes)')
				continue
			open(bm[1], 'wb').write(raw)
			if not bm[3]:
				print(f'{label}: {bm[1]} updated')
				continue
			subprocess.run(['rm', '-f', incbin])
			subprocess.run(MAKE + [incbin], capture_output=True)
			if os.path.exists(incbin) and open(incbin, 'rb').read() == de_lz:
				print(f'{label}: {bm[1]} updated, compression matches')
				continue
			found = None
			for fs in LZ_FLAG_SETS:
				for a in ALIGNS + ['0']:
					flags = ['--matching'] + fs + (['--align', a] if a else [])
					if lzcompress(bm[1], flags) == de_lz:
						found = flags
						break
				if found:
					break
			print(f'{label}: {bm[1]} updated; ' + (f'matching LZFLAGS: {" ".join(found[1:])}' if found else 'NO matching compression found'))
			continue
		stem, depth, lz = m[1], int(m[2]), bool(m[3])
		png = stem + '.png'
		target = f'{stem}.{depth}bpp'
		if not os.path.exists(png):
			print(f'{label}: {png} missing, skipped')
			continue
		fl = flags_for(target, mk)
		if fl.get('tools/gfx', '').strip() == '--trim-whitespace':
			pass  # PNG is padded to its old size; trailing blank tiles get trimmed again
		elif 'tools/gfx' in fl:
			print(f'{label}: {target} uses tools/gfx {fl["tools/gfx"]}, needs manual handling')
			continue
		off = rom_offset(e['bank'], e['addr'])
		subprocess.run(MAKE + [target], capture_output=True)
		en_raw = open(target, 'rb').read()
		if lz:
			raw, clen = decompress(rom, off)
			de_lz = rom[off:off + clen]
		else:
			raw = rom[off:off + len(en_raw)]
		if raw == en_raw:
			print(f'{label}: graphic unchanged')
			continue
		w, h, bitdepth, _ = png_size(png)
		columns = '--columns' in fl.get('RGBGFXFLAGS', '')
		trim = re.search(r'--trim-end (\d+)', fl.get('RGBGFXFLAGS', ''))
		ntiles = len(raw) // (8 * depth) + (int(trim[1]) if trim else 0)
		width_tiles = w // 8
		height_tiles = -(-ntiles // width_tiles) if not columns else h // 8
		if 'tools/gfx' in fl:
			height_tiles = max(height_tiles, h // 8)
		if len(raw) != len(en_raw):
			print(f'{label}: size {len(en_raw)} -> {len(raw)}')
		pix = tiles_to_pixels(raw, depth, width_tiles, columns, height_tiles)
		if args.dry_run:
			print(f'{label}: would write {png} ({width_tiles * 8}x{height_tiles * 8})')
			continue
		write_png(png, pix, bitdepth)
		subprocess.run(['rm', '-f', target, target + '.lz'])
		subprocess.run(MAKE + [target], capture_output=True)
		if open(target, 'rb').read() != raw:
			print(f'{label}: {png}: PNG round trip FAILED')
			continue
		if not lz:
			print(f'{label}: {png} updated')
			continue
		subprocess.run(MAKE + [target + '.lz'], capture_output=True)
		if open(target + '.lz', 'rb').read() == de_lz:
			print(f'{label}: {png} updated, compression matches')
			continue
		found = None
		for fs in LZ_FLAG_SETS:
			for a in ALIGNS:
				flags = ['--matching'] + fs + (['--align', a] if a else [])
				if lzcompress(target, flags) == de_lz:
					found = flags
					break
			if found:
				break
		if found:
			print(f'{label}: {png} updated; matching LZFLAGS: {" ".join(found[1:])}')
		else:
			print(f'{label}: {png} updated; NO matching compression found')


if __name__ == '__main__':
	main()
