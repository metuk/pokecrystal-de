"""
Pokémon Gold/Silver/Crystal LZ format (see tools/lzcompress.c, home/decompress.asm).
"""

LZ_END = 0xff


def decompress(rom, pos):
	"""Returns (decompressed bytes, compressed length)."""
	start = pos
	out = bytearray()
	while True:
		b = rom[pos]
		pos += 1
		if b == LZ_END:
			return bytes(out), pos - start
		cmd = b >> 5
		if cmd == 7:
			cmd = (b >> 2) & 7
			n = ((b & 3) << 8 | rom[pos]) + 1
			pos += 1
		else:
			n = (b & 0x1f) + 1
		if cmd == 0:  # literal
			out += rom[pos:pos + n]
			pos += n
		elif cmd == 1:  # iterate
			out += bytes([rom[pos]]) * n
			pos += 1
		elif cmd == 2:  # alternate
			a, c = rom[pos], rom[pos + 1]
			pos += 2
			out += bytes((a, c)[i & 1] for i in range(n))
		elif cmd == 3:  # blank
			out += bytes(n)
		else:
			o = rom[pos]
			pos += 1
			if o & 0x80:
				src = len(out) - (o & 0x7f) - 1
			else:
				src = o << 8 | rom[pos]
				pos += 1
			if cmd == 4:  # repeat
				for i in range(n):
					out.append(out[src + i])
			elif cmd == 5:  # flip
				for i in range(n):
					x = out[src + i]
					out.append(int(f'{x:08b}'[::-1], 2))
			elif cmd == 6:  # reverse
				for i in range(n):
					out.append(out[src - i])
