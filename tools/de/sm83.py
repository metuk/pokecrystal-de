"""
Minimal SM83 (Game Boy CPU) disassembler.
"""

R8 = ['b', 'c', 'd', 'e', 'h', 'l', '[hl]', 'a']
R16 = ['bc', 'de', 'hl', 'sp']
R16_STK = ['bc', 'de', 'hl', 'af']
R16_MEM = ['[bc]', '[de]', '[hli]', '[hld]']
COND = ['nz', 'z', 'nc', 'c']
ALU = ['add a,', 'adc a,', 'sub', 'sbc a,', 'and', 'xor', 'or', 'cp']
CB_ROT = ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'swap', 'srl']


def disasm_one(data, pos, pc, name=None):
	"""
	Returns (text, length, target) where target is a jump/call/load address or None.
	name(addr) -> optional symbol name for an address operand.
	"""
	name = name or (lambda a: None)

	def n8():
		return data[pos + 1]

	def n16():
		return data[pos + 1] | data[pos + 2] << 8

	def addr(a):
		s = name(a)
		return s if s else f'${a:04x}'

	op = data[pos]
	x, y, z = op >> 6, (op >> 3) & 7, op & 7
	if op == 0x00:
		return 'nop', 1, None
	if op == 0x08:
		return f'ld [{addr(n16())}], sp', 3, n16()
	if op == 0x10:
		return 'stop', 2, None
	if op == 0x18 or op in (0x20, 0x28, 0x30, 0x38):
		off = n8() - 256 if n8() >= 128 else n8()
		t = (pc + 2 + off) & 0xffff
		c = '' if op == 0x18 else COND[(op - 0x20) >> 3] + ', '
		return f'jr {c}{addr(t)}', 2, t
	if x == 0 and z == 1:
		if y & 1:
			return f'add hl, {R16[y >> 1]}', 1, None
		return f'ld {R16[y >> 1]}, {addr(n16())}', 3, n16()
	if x == 0 and z == 2:
		r = R16_MEM[y >> 1]
		return (f'ld a, {r}' if y & 1 else f'ld {r}, a'), 1, None
	if x == 0 and z == 3:
		return (f'dec {R16[y >> 1]}' if y & 1 else f'inc {R16[y >> 1]}'), 1, None
	if x == 0 and z == 4:
		return f'inc {R8[y]}', 1, None
	if x == 0 and z == 5:
		return f'dec {R8[y]}', 1, None
	if x == 0 and z == 6:
		return f'ld {R8[y]}, ${n8():02x}', 2, None
	if x == 0 and z == 7:
		return ['rlca', 'rrca', 'rla', 'rra', 'daa', 'cpl', 'scf', 'ccf'][y], 1, None
	if op == 0x76:
		return 'halt', 1, None
	if x == 1:
		return f'ld {R8[y]}, {R8[z]}', 1, None
	if x == 2:
		return f'{ALU[y]} {R8[z]}', 1, None
	if x == 3:
		if op in (0xc0, 0xc8, 0xd0, 0xd8):
			return f'ret {COND[y]}', 1, None
		if op == 0xe0:
			return f'ldh [${0xff00 + n8():04x}], a', 2, None
		if op == 0xf0:
			return f'ldh a, [${0xff00 + n8():04x}]', 2, None
		if op == 0xe8:
			return f'add sp, {n8()}', 2, None
		if op == 0xf8:
			return f'ld hl, sp+{n8()}', 2, None
		if z == 1:
			if y & 1:
				return ['ret', 'reti', 'jp hl', 'ld sp, hl'][y >> 1], 1, None
			return f'pop {R16_STK[y >> 1]}', 1, None
		if op in (0xc2, 0xca, 0xd2, 0xda):
			return f'jp {COND[y]}, {addr(n16())}', 3, n16()
		if op == 0xe2:
			return 'ldh [c], a', 1, None
		if op == 0xf2:
			return 'ldh a, [c]', 1, None
		if op == 0xea:
			return f'ld [{addr(n16())}], a', 3, n16()
		if op == 0xfa:
			return f'ld a, [{addr(n16())}]', 3, n16()
		if op == 0xc3:
			return f'jp {addr(n16())}', 3, n16()
		if op == 0xcb:
			cb = data[pos + 1]
			cx, cy, cz = cb >> 6, (cb >> 3) & 7, cb & 7
			if cx == 0:
				return f'{CB_ROT[cy]} {R8[cz]}', 2, None
			return f'{["", "bit", "res", "set"][cx]} {cy}, {R8[cz]}', 2, None
		if op == 0xf3:
			return 'di', 1, None
		if op == 0xfb:
			return 'ei', 1, None
		if op in (0xc4, 0xcc, 0xd4, 0xdc):
			return f'call {COND[y]}, {addr(n16())}', 3, n16()
		if z == 5:
			if y & 1:
				if op == 0xcd:
					return f'call {addr(n16())}', 3, n16()
				return f'db ${op:02x}', 1, None
			return f'push {R16_STK[y >> 1]}', 1, None
		if z == 6:
			return f'{ALU[y]} ${n8():02x}', 2, None
		if z == 7:
			return f'rst ${y * 8:02x}', 1, None
	return f'db ${op:02x}', 1, None


def disasm(data, start, end, pc, name=None):
	"""Yields (rom offset, pc, text, bytes)."""
	pos = start
	while pos < end:
		text, n, _ = disasm_one(data, pos, pc, name)
		yield pos, pc, text, data[pos:pos + n]
		pos += n
		pc += n
