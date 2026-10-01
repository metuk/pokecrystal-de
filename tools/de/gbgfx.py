"""
Convert raw Game Boy tile data (1bpp/2bpp) to PNGs in pret's conventions
(grayscale, white = color 0, as read by `rgbgfx --colors dmg`), and read PNG sizes.
"""

import struct
import zlib


def png_size(path):
	with open(path, 'rb') as f:
		head = f.read(33)
	w, h = struct.unpack('>II', head[16:24])
	bitdepth, colortype = head[24], head[25]
	return w, h, bitdepth, colortype


def tiles_to_pixels(data, depth, width_tiles, columns=False, height_tiles=None):
	"""Returns rows of color indices (0-3)."""
	tile_size = 8 * depth
	ntiles = len(data) // tile_size
	if height_tiles is None:
		height_tiles = -(-ntiles // width_tiles)
	w, h = width_tiles * 8, height_tiles * 8
	pix = [[0] * w for _ in range(h)]
	for t in range(ntiles):
		if columns:
			tx, ty = t // height_tiles, t % height_tiles
		else:
			tx, ty = t % width_tiles, t // width_tiles
		tile = data[t * tile_size:(t + 1) * tile_size]
		for y in range(8):
			if depth == 2:
				lo, hi = tile[2 * y], tile[2 * y + 1]
			else:
				lo, hi = tile[y], 0
			for x in range(8):
				bit = 7 - x
				c = ((lo >> bit) & 1) | (((hi >> bit) & 1) << 1)
				if depth == 1:
					c = 3 if c else 0
				pix[ty * 8 + y][tx * 8 + x] = c
	return pix


def write_png(path, pix, bitdepth=2):
	"""Write a grayscale PNG; color index c -> gray level (3 - c) scaled to bitdepth."""
	h, w = len(pix), len(pix[0])
	maxv = (1 << bitdepth) - 1
	raw = bytearray()
	for row in pix:
		raw.append(0)
		bits = 0
		nbits = 0
		for c in row:
			v = (3 - c) * maxv // 3
			bits = (bits << bitdepth) | v
			nbits += bitdepth
			if nbits == 8:
				raw.append(bits)
				bits = nbits = 0
		if nbits:
			raw.append(bits << (8 - nbits))

	def chunk(t, d):
		c = struct.pack('>I', len(d)) + t + d
		return c + struct.pack('>I', zlib.crc32(t + d) & 0xffffffff)

	png = b'\x89PNG\r\n\x1a\n'
	png += chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, bitdepth, 0, 0, 0, 0))
	png += chunk(b'IDAT', zlib.compress(bytes(raw), 9))
	png += chunk(b'IEND', b'')
	open(path, 'wb').write(png)
