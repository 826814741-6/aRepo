#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
#

def mulA(a, b):
    r = 0
    while a != 0:
        if a % 2 == 1:
            r += b
        b, a = b * 2, a // 2
    return r

def mulB(a, b):
    r = 0
    while a != 0:
        if a & 1 == 1:
            r += b
        b, a = b << 1, a >> 1
    return r

def mulC(a, b):
    def _iter(a, b, r):
        return _iter(a>>1, b<<1, r+b if a&1==1 else r) if a != 0 else r
    return _iter(a, b, 0)
