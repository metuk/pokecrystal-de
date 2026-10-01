#!/usr/bin/env python3
"""
Replace English string data (names, descriptions, Pokédex entries, trainer
names, ...) with the German strings from baserom.gbc.

For each label with a known German address (de_syms.json), the lines after it
are walked in step with the German bytes:
	li "X"                  -> string up to "@"
	dname "X"[, n]          -> fixed-length name padded with "@"
	db/next/line/para/cont/page "X"  (string runs ending in "@")
	db "X@", 1, 2           -> string part replaced, numbers kept
	db 1, 2 / dw 1, 2       -> kept (cursor advances); numeric dw replaced
Unknown lines stop the walk for that label.

Usage: tools/de/restring.py [-n] [files...]
"""

import argparse
import glob
import json
import os
import re
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(__file__))
from textlib import load_charmap, quote_chars
from rgbobj import load_sym_addresses, rom_offset

LABEL = re.compile(r'^(\.?[A-Za-z_][\w.]*)(::?)\s*(.*)$')
STRING_MACROS = {'db', 'next', 'line', 'para', 'cont', 'page'}
SPLITS = {0x4e: 'next', 0x4f: 'line', 0x51: 'para', 0x55: 'cont'}
ZERO_SIZE = {'table_width', 'list_start', 'assert_table_length', 'assert_list_length', 'assert'}


def load_constants():
	consts = {}
	for path in glob.glob('**/*.asm', recursive=True):
		for line in open(path, encoding='utf-8'):
			m = re.match(r'\s*DEF (\w+)\s+EQU\s+(\$?[0-9a-fA-F]+)\b', line)
			if m:
				v = m[2]
				consts[m[1]] = int(v[1:], 16) if v.startswith('$') else int(v)
	return consts


def split_args(s):
	"""Split macro arguments on commas outside of string literals."""
	args, cur, q = [], '', False
	for ch in s:
		if ch == '"':
			q = not q
		if ch == ',' and not q:
			args.append(cur.strip())
			cur = ''
		else:
			cur += ch
	if cur.strip():
		args.append(cur.strip())
	return args


def strip_comment(s):
	q = False
	for i, ch in enumerate(s):
		if ch == '"':
			q = not q
		elif ch == ';' and not q:
			return s[:i].rstrip(), s[i:]
	return s.rstrip(), ''


class Walker:
	def __init__(self, rom, decode, consts, built=None):
		self.rom = rom
		self.built = built
		self.decode = decode
		self.consts = consts

	def eval(self, expr):
		e = expr
		for name in sorted(set(re.findall(r'[A-Za-z_]\w*', e)), key=len, reverse=True):
			if name not in self.consts:
				raise ValueError(name)
			e = re.sub(rf'\b{name}\b', str(self.consts[name]), e)
		e = re.sub(r'\$([0-9a-fA-F]+)', r'0x\1', e).replace('%', '0b')
		return int(eval(e, {}))

	def read_string(self, pos, rom=None, limit=0x400):
		"""Read up to and including "@". Returns (bytes, newpos)."""
		rom = rom or self.rom
		end = rom.index(0x50, pos, pos + limit)
		return rom[pos:end + 1], end + 1

	def read_run(self, rom, pos, pages):
		"""Bytes of a string run with `pages` page breaks, up to the final "@"."""
		start = pos
		ats = 0
		while True:
			b = rom[pos]
			pos += 1
			if b == 0x50:
				ats += 1
				if ats > pages:
					return rom[start:pos], pos

	def interpolate(self, en_args, de_text):
		"""Put {d:CONST} interpolations of the English string back where the value matches."""
		for m in re.finditer(r'\{d:(\w+)\}', en_args):
			v = self.consts.get(m[1])
			if v is not None and de_text.count(str(v)) == 1:
				de_text = de_text.replace(str(v), m[0])
		return de_text

	def walk(self, lines, start, pos, bpos=None):
		"""
		Walk source lines from index `start` with German cursor `pos`.
		Returns (dict line index -> new line(s), stop reason).
		"""
		out = {}
		i = start
		run = None  # pending string run: list of (line index, macro, indent, comment)
		while i < len(lines):
			raw = lines[i]
			code, comment = strip_comment(raw)
			s = code.strip()
			if not s:
				i += 1
				continue
			if LABEL.match(code) and not code.startswith('\t'):
				return out, 'label'
			parts = s.split(None, 1)
			macro, rest = parts[0], parts[1] if len(parts) > 1 else ''
			args = split_args(rest)
			indent = raw[:len(raw) - len(raw.lstrip())]

			if macro in ZERO_SIZE:
				i += 1
				continue

			if macro == 'li' and len(args) == 1 and args[0].startswith('"'):
				data, pos = self.read_string(pos)
				en, bpos = self.read_string(bpos, self.built)
				if data != en:
					new = self.interpolate(args[0], quote_chars(list(data[:-1]), self.decode))
					out[i] = f'{indent}li {new}' + (f' {comment}' if comment else '')
				i += 1
				continue

			if macro == 'dname' and args and args[0].startswith('"'):
				n = self.eval(args[1]) if len(args) > 1 else self.consts['NAME_LENGTH'] - 1
				data = self.rom[pos:pos + n]
				pos += n
				en = self.built[bpos:bpos + n]
				bpos += n
				if data == en:
					i += 1
					continue
				name = bytes(data).rstrip(b'\x50')
				if 0x50 in name:
					return out, f'line {i + 1}: "@" inside dname'
				extra = f', {args[1]}' if len(args) > 1 else ''
				out[i] = f'{indent}dname {quote_chars(list(name), self.decode)}{extra}' + (f' {comment}' if comment else '')
				i += 1
				continue

			if macro in STRING_MACROS and args and args[0].startswith('"'):
				# A run of string lines ending with a line whose string ends in "@"
				# (or a db "X@", n, ... line): collect it, then decode the German run.
				j = i
				run = []
				pages = 0
				while j < len(lines):
					c2, cm2 = strip_comment(lines[j])
					s2 = c2.strip()
					if not s2:
						j += 1
						continue
					p2 = s2.split(None, 1)
					m2 = p2[0]
					a2 = split_args(p2[1]) if len(p2) > 1 else []
					if m2 not in STRING_MACROS or not a2 or not a2[0].startswith('"'):
						return out, f'line {j + 1}: unterminated string run'
					if m2 == 'page':
						pages += 1
					run.append((j, m2, lines[j][:len(lines[j]) - len(lines[j].lstrip())], cm2, a2))
					if a2[0].endswith('@"'):
						break
					if len(a2) > 1:
						return out, f'line {j + 1}: string not terminated by "@"'
					j += 1
				last_args = run[-1][4]
				tail_args = last_args[1:] if run[-1][1] == 'db' else []
				de_bytes, _ = self.read_run(self.rom, pos, pages)
				en_bytes, bpos = self.read_run(self.built, bpos, pages)
				if de_bytes == en_bytes:
					pos += len(de_bytes) + len(tail_args)
					bpos += len(tail_args)
					i = run[-1][0] + 1
					continue
				en_all = ' '.join(r[4][0] for r in run)
				# German bytes: strings with page breaks, then the tail bytes (kept as is)
				segs = []  # (macro, chars)
				macro_now = run[0][1]
				chars = []
				ats = 0
				while True:
					b = self.rom[pos]
					pos += 1
					if b == 0x50:
						ats += 1
						if ats > pages:
							chars.append(b)
							segs.append((macro_now, chars))
							break
						segs.append((macro_now, chars))
						macro_now, chars = 'page', []
						continue
					if b in SPLITS:
						segs.append((macro_now, chars))
						macro_now, chars = SPLITS[b], []
						continue
					chars.append(b)
				if tail_args:
					size = 0
					for a in tail_args:
						if a.startswith('"'):
							return out, f'line {run[-1][0] + 1}: string after terminator'
						size += 1
					pos += size
					bpos += size
				# emit: reuse indentation/spacing style of the first line
				first_idx = run[0][0]
				ind = run[0][2]
				new = []
				pad = max(len(m) for m, _ in segs)
				for k, (m, ch) in enumerate(segs):
					arg = self.interpolate(en_all, quote_chars(ch, self.decode))
					if k == len(segs) - 1 and tail_args:
						arg += ', ' + ', '.join(tail_args)
					if m == 'db' and pad > 2:
						new.append(f'{ind}db   {arg}')
					else:
						new.append(f'{ind}{m} {arg}')
				out[first_idx] = new
				for k in run[1:]:
					out[k[0]] = None
				# keep a comment on the first line
				if run[0][3]:
					out[first_idx][0] += f' {run[0][3]}'
				i = run[-1][0] + 1
				continue

			if macro in ('db', 'dw') and args and not any(a.startswith('"') for a in args):
				size = (1 if macro == 'db' else 2) * len(args)
				if macro == 'dw' and all(re.fullmatch(r'\d+', a) for a in args):
					vals = [self.rom[pos + 2 * k] | self.rom[pos + 2 * k + 1] << 8 for k in range(len(args))]
					if vals != [int(a) for a in args]:
						out[i] = f'{indent}dw {", ".join(str(v) for v in vals)}' + (f' {comment}' if comment else '')
				pos += size
				bpos += size
				i += 1
				continue

			if macro == 'INCLUDE':
				return out, 'include'
			return out, f'line {i + 1}: unknown line "{s[:40]}"'
		return out, 'eof'


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument('files', nargs='*')
	ap.add_argument('-n', '--dry-run', action='store_true')
	ap.add_argument('-v', '--verbose', action='store_true')
	args = ap.parse_args()

	rom = open('baserom.gbc', 'rb').read()
	decode, _ = load_charmap()
	de = json.load(open('de_syms.json'))
	built = open('pokecrystal-de.gbc', 'rb').read()
	built_syms = load_sym_addresses('pokecrystal-de.sym')
	walker = Walker(rom, decode, load_constants(), built)
	files = args.files or sorted(set(glob.glob('data/**/*.asm', recursive=True)) | set(glob.glob('engine/**/*.asm', recursive=True)) | set(glob.glob('mobile/**/*.asm', recursive=True)) | set(glob.glob('home/**/*.asm', recursive=True)) | set(glob.glob('maps/*.asm')))
	stats = Counter()
	# INCLUDEs right after a label: process the included file at that address
	includes = {}
	for path in files:
		for line in open(path, encoding='utf-8'):
			m = re.match(r'^(\w+)::?\s+INCLUDE "(.*)"', line)
			if m:
				includes[m[2]] = m[1]

	todo = list(files) + [f for f in includes if f not in files]
	for path in todo:
		if not os.path.exists(path):
			continue
		lines = open(path, encoding='utf-8').read().split('\n')
		changes = {}
		starts = []
		if path in includes:
			e = de.get(includes[path])
			if e and includes[path] in built_syms:
				starts.append((0, rom_offset(e['bank'], e['addr']), includes[path]))
		scope = None
		other_charmap = False
		for i, l in enumerate(lines):
			cm = re.match(r'\s*(pushc|setcharmap)\s+(\w+)', l)
			if cm:
				other_charmap = cm[2] != 'main'
			elif re.match(r'\s*popc\b', l):
				other_charmap = False
			m = LABEL.match(l)
			if not m or l.startswith('\t') or other_charmap:
				continue
			name = m[1]
			if name.startswith('.'):
				name = f'{scope}{name}'
			else:
				scope = name
			if m[3] and not m[3].startswith(';'):
				continue
			e = de.get(name)
			if e and name in built_syms:
				starts.append((i + 1, rom_offset(e['bank'], e['addr']), name))
		for start, pos, name in starts:
			try:
				out, why = walker.walk(lines, start, pos, rom_offset(*built_syms[name]))
			except (ValueError, IndexError) as ex:
				stats['error'] += 1
				if args.verbose:
					print(f'{path}: {name}: {ex!r}')
				continue
			changed = {k: v for k, v in out.items() if v is None or v != lines[k] and v != [lines[k]]}
			if changed:
				stats['labels_changed'] += 1
				changes.update(out)
			if args.verbose and why not in ('label', 'eof', 'include'):
				print(f'{path}: {name}: stopped at {why}')
		if changes and not args.dry_run:
			new = []
			for i, l in enumerate(lines):
				if i in changes:
					v = changes[i]
					if v is None:
						continue
					new += v if isinstance(v, list) else [v]
				else:
					new.append(l)
			if new != lines:
				stats['files_changed'] += 1
				open(path, 'w', encoding='utf-8').write('\n'.join(new))
	for k, v in stats.most_common():
		print(f'{k}: {v}')


if __name__ == '__main__':
	main()
