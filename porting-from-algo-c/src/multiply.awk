#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	iMulA(, iMulB, iMulC)
#

function iMulA(a, b,	r) {
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
#function iMulB(a, b,	r) {
#	r = 0
#	while (a) {
#		if (_and(a,1)) r += b
#		b=_lshift(b,1); a=_rshift(a,1)
#	}
#	return r
#}
#
#function _rec(a, b, r) {
#	return a ? _rec(_rshift(a,1), _lshift(b,1), _and(a,1)?r+b:r) : r
#}
#function iMulC(a, b) {
#	return _rec(a, b, 0)
#}
#

# in GAWK
#
# 9.1.6 Bit-Manipulation Functions
# https://www.gnu.org/software/gawk/manual/html_node/Bitwise-Functions.html
#
#function iMulB(a, b,	r) {
#	r = 0
#	while (a) {
#		if (and(a,1)) r += b
#		b=lshift(b,1); a=rshift(a,1)
#	}
#	return r
#}
#
#function _rec(a, b, r) {
#	return a ? _rec(rshift(a,1), lshift(b,1), and(a,1)?r+b:r) : r
#}
#function iMulC(a, b) {
#	return _rec(a, b, 0)
#}

#

BEGIN {
	printf "%s, %s, %s, %s -> %d, %d, %.2f, %.2f\n",
		"2*3", "iMulA(2,3)", "2.1*3.1", "iMulA(2.1,3.1)", 2*3, iMulA(2,3), 2.1*3.1, iMulA(2.1,3.1)
	#printf "%s, %s, %s, %s -> %d, %d, %.2f, %.2f\n",
	#	"2*3", "iMulB(2,3)", "2.1*3.1", "iMulB(2.1,3.1)", 2*3, iMulB(2,3), 2.1*3.1, iMulB(2.1,3.1)
	#printf "%s, %s, %s, %s -> %d, %d, %.2f, %.2f\n",
	#	"2*3", "iMulC(2,3)", "2.1*3.1", "iMulC(2.1,3.1)", 2*3, iMulC(2,3), 2.1*3.1, iMulC(2.1,3.1)
}
