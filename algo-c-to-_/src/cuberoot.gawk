#
#	from src/cuberoot.c
#
#	double cuberoot(double)		to	fCbrt
#	double cuberoot2(double)	to	fCbrt2
#
#	from src/icubrt.c
#
#	unsigned icubrt(unsigned)	to	iCbrt
#

#
#	abs(n), atLeastOne(n) from _helper.awk
#

function fCbrt(x,	isPositive, ax, t, prev) {
	if (x == 0) return 0

	isPositive = x > 0
	ax = atLeastOne(abs(x)); t = ax

	do {
		prev = t
		t = (ax / (t * t) + 2 * t) / 3
	} while (t < prev)

	return isPositive ? prev : -prev
}

function fCbrt2(x,	isPositive, ax, t, prev) {
	if (x == 0) return 0

	isPositive = x > 0
	ax = atLeastOne(abs(x)); t = ax

	do {
		prev = t
		t = t + (ax - t * t * t) / (2 * t * t + ax / t)
	} while (t < prev)

	return isPositive ? prev : -prev
}

function iCbrt(x,	r, t) {
	if (x <= 0) return 0

	r = x; t = 1
	while (t < r) {
		r = rshift(r, 2); t = lshift(t, 1)
	}

	do {
		r = t; t = int((int(x / (t*t)) + 2*t) / 3)
	} while (t < r)

	return r
}
