"""
Minimal parser for RGBDS object files (format "RGB9", see rgbds(5)),
plus helpers to place each object section in the linked ROM via the .sym file.
"""

import struct

ROM_TYPES = (2, 3)  # ROMX, ROM0

PATCH_SIZES = {0: 1, 1: 2, 2: 4, 3: 1}


class Reader:
	def __init__(self, data):
		self.data = data
		self.pos = 0

	def long(self):
		v, = struct.unpack_from('<i', self.data, self.pos)
		self.pos += 4
		return v

	def byte(self):
		v = self.data[self.pos]
		self.pos += 1
		return v

	def string(self):
		end = self.data.index(0, self.pos)
		s = self.data[self.pos:end].decode('utf-8', 'replace')
		self.pos = end + 1
		return s

	def bytes(self, n):
		v = self.data[self.pos:self.pos + n]
		self.pos += n
		return v


class Symbol:
	def __init__(self, name, type, section=-1, value=0):
		self.name = name
		self.type = type
		self.section = section
		self.value = value


class Patch:
	def __init__(self, offset, type, rpn, pc_section, pc_offset):
		self.offset = offset
		self.type = type
		self.rpn = rpn
		self.pc_section = pc_section
		self.pc_offset = pc_offset

	@property
	def size(self):
		return PATCH_SIZES[self.type]


class Section:
	def __init__(self, name, size, type, address, bank, data, patches, fragment, union):
		self.name = name
		self.size = size
		self.type = type
		self.address = address
		self.bank = bank
		self.data = data
		self.patches = patches
		self.fragment = fragment
		self.union = union
		self.symbols = []  # Symbols defined in this section
		self.rom_offset = None  # Filled in by place_sections()


class ObjectFile:
	def __init__(self, path):
		self.path = path
		r = Reader(open(path, 'rb').read())
		magic = r.bytes(4)
		if magic != b'RGB9':
			raise ValueError(f'{path}: bad magic {magic!r}')
		r.long()  # revision
		nsyms = r.long()
		nsects = r.long()

		for _ in range(r.long()):
			r.long()  # parent id
			r.long()  # parent line
			t = r.byte()
			if t & 0x7f:
				r.string()
			else:
				r.bytes(4 * r.long())

		self.symbols = []
		for _ in range(nsyms):
			name = r.string()
			t = r.byte()
			if t != 1:
				r.long()  # node
				r.long()  # line
				sect = r.long()
				value = r.long()
				self.symbols.append(Symbol(name, t, sect, value))
			else:
				self.symbols.append(Symbol(name, t))

		self.sections = []
		for _ in range(nsects):
			name = r.string()
			r.long()  # node
			r.long()  # line
			size = r.long()
			t = r.byte()
			address = r.long()
			bank = r.long()
			r.byte()  # align
			r.long()  # align ofs
			data = None
			patches = []
			stype = t & 7
			if stype in ROM_TYPES:
				data = r.bytes(size)
				for _ in range(r.long()):
					r.long()
					r.long()
					offset = r.long()
					pcs = r.long()
					pco = r.long()
					pt = r.byte()
					rpn = r.bytes(r.long())
					patches.append(Patch(offset, pt, rpn, pcs, pco))
			self.sections.append(Section(name, size, stype, address, bank, data, patches,
				bool(t & 0x40), bool(t & 0x80)))

		for sym in self.symbols:
			if sym.type != 1 and 0 <= sym.section < len(self.sections):
				self.sections[sym.section].symbols.append(sym)


def parse_rpn(rpn, symbols):
	"""
	Decode an RPN expression into a list of tokens:
	('sym', name) ('bank_sym', name) ('bank_sect', name) ('int', v) ('op', code) ...
	"""
	tokens = []
	i = 0
	while i < len(rpn):
		op = rpn[i]
		i += 1
		if op in (0x50, 0x81):
			sid, = struct.unpack_from('<i', rpn, i)
			i += 4
			tokens.append(('bank_sym' if op == 0x50 else 'sym', symbols[sid].name))
		elif op in (0x51, 0x53, 0x54):
			end = rpn.index(0, i)
			name = rpn[i:end].decode()
			i = end + 1
			tokens.append(({0x51: 'bank_sect', 0x53: 'sizeof', 0x54: 'startof'}[op], name))
		elif op in (0x55, 0x56):
			tokens.append(('op', op, rpn[i]))
			i += 1
		elif op == 0x62:
			tokens.append(('op', op, rpn[i]))
			i += 1
		elif op == 0x80:
			v, = struct.unpack_from('<i', rpn, i)
			i += 4
			tokens.append(('int', v))
		else:
			tokens.append(('op', op))
	return tokens


def classify_patch(tokens):
	"""
	Recognize the common simple patch shapes. Returns (kind, symbol, addend) or None.
	kind: 'addr' (symbol+addend), 'bank' (BANK(symbol)), 'high', 'low', 'jr'
	"""
	addend = 0
	toks = list(tokens)
	wrap = None
	if toks and toks[-1] in (('op', 0x70), ('op', 0x71)):
		wrap = 'high' if toks[-1] == ('op', 0x70) else 'low'
		toks = toks[:-1]
	if len(toks) == 3 and toks[1][0] == 'int' and toks[2] in (('op', 0x00), ('op', 0x01)):
		addend = toks[1][1] if toks[2] == ('op', 0x00) else -toks[1][1]
		toks = toks[:1]
	elif len(toks) == 3 and toks[0][0] == 'int' and toks[2] == ('op', 0x00):
		addend = toks[0][1]
		toks = toks[1:2]
	if len(toks) == 1:
		kind, name = toks[0][0], toks[0][1] if len(toks[0]) > 1 else None
		if kind == 'sym':
			return (wrap or 'addr', name, addend)
		if kind == 'bank_sym' and not wrap and not addend:
			return ('bank', name, 0)
	return None


def load_objects(paths):
	return [ObjectFile(p) for p in paths]


def load_sym_addresses(sym_path):
	"""Map symbol name -> (bank, address) from a .sym file."""
	syms = {}
	with open(sym_path) as f:
		for line in f:
			if line.startswith(';'):
				continue
			parts = line.split()
			if len(parts) != 2 or ':' not in parts[0]:
				continue
			bank, addr = parts[0].split(':')
			syms[parts[1]] = (int(bank, 16), int(addr, 16))
	return syms


def rom_offset(bank, addr):
	return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)


def place_sections(objects, sym_addrs, map_sections=None):
	"""
	Set .rom_offset (and .bank/.address as linked) for each ROM section,
	using any symbol defined inside it. Falls back to the section name in
	map_sections ({name: rom_offset}) for symbol-less, non-fragment sections.
	"""
	for obj in objects:
		for sect in obj.sections:
			if sect.type not in ROM_TYPES:
				continue
			for sym in sect.symbols:
				if sym.name in sym_addrs:
					bank, addr = sym_addrs[sym.name]
					if addr >= 0x8000:
						continue
					sect.rom_offset = rom_offset(bank, addr) - sym.value
					break
			else:
				if map_sections and not sect.fragment and sect.name in map_sections:
					sect.rom_offset = map_sections[sect.name]
