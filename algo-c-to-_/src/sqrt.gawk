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

function iSqrt(x,	r, t) {
	if (x <= 0) return 0

	r = x; t = 1
	while (t < r) {
		r = rshift(r, 1); t = lshift(t, 1)
	}
	do {
		r = t; t = rshift(int(x / t) + t, 1)
	} while (t < r)

	return r
}
