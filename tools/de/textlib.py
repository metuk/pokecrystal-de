"""
Decode text command streams (see macros/scripts/text.asm) from a ROM into
pret-style text macros, and encode them back for round-trip checks.
"""

import re

STRING_END = 0x50

# string control chars that begin a new macro line
LINE_MACROS = {
	0x4e: 'next',
	0x4f: 'line',
	0x51: 'para',
	0x55: 'cont',
}
# string control chars that end the whole text
END_MACROS = {
	0x57: 'done',
	0x58: 'prompt',
}

# text commands: id -> (name, arg kinds); 'w' = word, 'b' = byte
COMMANDS = {
	0x01: ('text_ram', 'w'),
	0x02: ('text_bcd', 'wb'),
	0x03: ('text_move', 'w'),
	0x04: ('text_box', 'wbb'),
	0x05: ('text_low', ''),
	0x06: ('text_promptbutton', ''),
	0x07: ('text_scroll', ''),
	0x08: ('text_asm', ''),
	0x09: ('text_decimal', 'wn'),
	0x0a: ('text_pause', ''),
	0x0b: ('sound_dex_fanfare_50_79', ''),
	0x0c: ('text_dots', 'b'),
	0x0d: ('text_waitbutton', ''),
	0x0e: ('sound_dex_fanfare_20_49', ''),
	0x0f: ('sound_item', ''),
	0x10: ('sound_caught_mon', ''),
	0x11: ('sound_dex_fanfare_80_109', ''),
	0x12: ('sound_fanfare', ''),
	0x13: ('sound_slot_machine_start', ''),
	0x14: ('text_buffer', 'b'),
	0x15: ('text_today', ''),
	0x16: ('text_far', 'f'),
}

# multi-char charmap entries that a plain string could accidentally produce
AMBIGUOUS_PREFIXES = ("'",)


def load_charmap(path='constants/charmap.asm'):
	"""Returns (decode: byte -> str, encode: str -> byte) for the main (text) charmap."""
	decode = {}
	encode = {}
	section = 'main'
	for line in open(path, encoding='utf-8'):
		if line.startswith('; Actual characters (from gfx/font/font_battle_extra'):
			section = 'battle'
		elif line.startswith('; Actual characters (from gfx/font/font.png') or 'gfx/font/font.png' in line:
			section = 'main'
		m = re.match(r'\s*charmap "(.*?)",\s*\$([0-9a-fA-F]{2})', line)
		if not m:
			continue
		s, b = m[1], int(m[2], 16)
		encode.setdefault(s, b)
		if section == 'main':
			decode.setdefault(b, s)
	return decode, encode


class TextError(Exception):
	pass


def quote_chars(chars, decode):
	"""
	chars: list of bytes forming plain text (no controls that start macros).
	Returns the macro argument list as asm (e.g. '"Hallo", $60, "!"').
	"""
	parts = []
	cur = ''
	for i, b in enumerate(chars):
		s = decode.get(b)
		if s is None or s in ('"', '\\', '{', '}'):
			if cur:
				parts.append(f'"{cur}"')
				cur = ''
			parts.append(f'${b:02x}')
			continue
		# don't let "'" + letter be re-encoded as a single "'d"-style char
		if cur.endswith("'") and len(s) == 1 and ("'" + s) in ENC_MULTI:
			parts.append(f'"{cur}"')
			cur = ''
		cur += s
	if cur or not parts:
		parts.append(f'"{cur}"')
	return ', '.join(parts)


ENC_MULTI = set()


def decode_text(rom, off, decode, name_word=None, name_far=None, max_len=0x1000):
	"""
	Decode a text command stream at rom offset `off`.
	name_word(value) -> asm expression for a RAM address operand.
	name_far(bank, addr) -> label name for a text_far target.
	Returns (list of asm lines without leading tab, end offset).
	"""
	global ENC_MULTI
	ENC_MULTI = {s for s in decode.values() if len(s) == 2 and s[0] == "'"}
	name_word = name_word or (lambda v: f'${v:04x}')
	lines = []
	pos = off
	limit = off + max_len

	def word():
		nonlocal pos
		v = rom[pos] | rom[pos + 1] << 8
		pos += 2
		return v

	while pos < limit:
		cmd = rom[pos]
		pos += 1
		if cmd == 0x00:
			macro = 'text'
			chars = []

			def flush():
				if macro == 'text' and not chars:
					lines.append('text_start')
				else:
					lines.append(f'{macro} {quote_chars(chars, decode)}')

			while True:
				if pos >= limit:
					raise TextError('unterminated string')
				b = rom[pos]
				pos += 1
				if b in LINE_MACROS:
					flush()
					macro, chars = LINE_MACROS[b], []
				elif b in END_MACROS:
					flush()
					lines.append(END_MACROS[b])
					return lines, pos
				elif b == STRING_END:
					chars.append(b)
					flush()
					break
				else:
					chars.append(b)
			continue
		if cmd == STRING_END:
			lines.append('text_end')
			return lines, pos
		if cmd not in COMMANDS:
			raise TextError(f'unknown text command ${cmd:02x} at {pos - 1:#x}')
		name, kinds = COMMANDS[cmd]
		args = []
		for k in kinds:
			if k == 'w':
				args.append(name_word(word()))
			elif k == 'b':
				args.append(str(rom[pos]))
				pos += 1
			elif k == 'n':
				v = rom[pos]
				pos += 1
				args += [str(v >> 4), str(v & 0xf)]
			elif k == 'f':
				addr = word()
				bank = rom[pos]
				pos += 1
				if not name_far:
					raise TextError('text_far without resolver')
				args.append(name_far(bank, addr))
		lines.append(name + (' ' + ', '.join(args) if args else ''))
		if cmd == 0x08:
			return lines, pos
	raise TextError('text too long')


def format_block(lines):
	"""Indent and insert pret-style blank lines before 'para'."""
	out = []
	for i, l in enumerate(lines):
		if l.startswith('para') and i:
			out.append('')
		out.append('\t' + l)
	return out
