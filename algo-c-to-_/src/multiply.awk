#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	mulA(, mulB, mulC)
#

function mulA(a, b,	r) {
	r = 0
	while (a) {
		if (a%2) r += b
		b=b*2; a=int(a/2)
	}
	return r
}

# see http://www.intex.tokyo/unix/awk-02.html
#function _and(x, y,	...) {
#	...
#}
#function _lshift(x, y,	...) {
#	...
#}
#function _rshift(x, y,	...) {
#	...
#}
#
#function mulB(a, b,	r) {
#	r = 0
#	while (a) {
#		if (_and(a,1)) r += b
#		b=_lshift(b,1); a=_rshift(a,1)
#	}
#	return r
#}
#
#function _iter(a, b, r) {
#	return a ? _iter(_rshift(a,1), _lshift(b,1), _and(a,1)?r+b:r) : r
#}
#function mulC(a, b) {
#	return _iter(a, b, 0)
#}
