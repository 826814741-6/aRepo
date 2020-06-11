#
#	from src/sqrt.c
#
#	double mysqrt(double)		to	fSqrt
#
#	from src/isqrt.c
#
#	unsigned isqrt(unsigned)	to	iSqrt
#

#
#	atLeastOne(n) from _helper.awk
#

function fSqrt(x,	r, t) {
	if (x <= 0) return 0

	t = atLeastOne(x)
	do {
		r = t; t = (x / t + t) / 2
	} while (t < r)

	return r
}

# see http://www.intex.tokyo/unix/awk-02.html
#function _lshift(x, y,	...) {
#	...
#}
#function _rshift(x, y,	...) {
#	...
#}
#
#function iSqrt(x,	r, t) {
#	if (x <= 0) return 0
#
#	r = x; t = 1
#	while (t < r) {
#		r = _rshift(r, 1); t = _lshift(t, 1)
#	}
#	do {
#		r = t; t = _rshift(int(x / t) + t, 1)
#	} while (t < r)
#
#	return r
#}

function iSqrt(x,	r, t) {
	if (x <= 0) return 0

	r = x; t = 1
	while (t < r) {
		r = int(r / 2); t = t * 2
	}
	do {
		r = t; t = int((int(x / t) + t) / 2)
	} while (t < r)

	return r
}
