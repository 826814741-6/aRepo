#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
#

function mulA(a, b,	r) {
	r = 0
	while (a) {
		if (a%2) r += b
		b=b*2; a=int(a/2)
	}
	return r
}

#	only GAWK
function mulB(a, b,	r) {
	r = 0
	while (a) {
		if (and(a,1)) r += b
		b=lshift(b,1); a=rshift(a,1)
	}
	return r
}

function _iter(a, b, r) {
	return a ? _iter(rshift(a,1), lshift(b,1), and(a,1)?r+b:r) : r
}
function mulC(a, b) {
	return _iter(a, b, 0)
}
