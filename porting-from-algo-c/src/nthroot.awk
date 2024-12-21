#
#	from src/sqrt.c
#
#	double mysqrt(double)		to	fSqrt
#
#	from src/isqrt.c
#
#	unsigned isqrt(unsigned)	to	iSqrt
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
		r = int(r / 2); t = t * 2
	}
	do {
		r = t; t = int((int(x / t) + t) / 2)
	} while (t < r)

	return r
}

# in GAWK
#
# 9.1.6 Bit-Manipulation Functions
# https://www.gnu.org/software/gawk/manual/html_node/Bitwise-Functions.html
#
#function iSqrt(x,	r, t) {
#	if (x <= 0) return 0
#
#	r = x; t = 1
#	while (t < r) {
#		r = rshift(r, 1); t = lshift(t, 1)
#	}
#	do {
#		r = t; t = rshift(int(x / t) + t, 1)
#	} while (t < r)
#
#	return r
#}

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
		r = int(r / 4); t *= 2 # <-
		#
		# r = rshift(r, 2); t = lshift(t, 1) # <- plan B in GAWK
		#
		# 9.1.6 Bit-Manipulation Functions
		# https://www.gnu.org/software/gawk/manual/html_node/Bitwise-Functions.html
		#
	}

	do {
		r = t; t = int((int(x / (t*t)) + 2*t) / 3)
	} while (t < r)

	return r
}

#

#
#	_p(b) from _helper.awk
#

function _t_iSqrt(l, r,		i, t) {
	for (i = l; i < r; i++) {
		t = iSqrt(i)
		if (t * t > i || (t+1) * (t+1) <= i) {
			printf "ERROR: %d %d\n", i, t
			exit
		}
	}
	printf "iSqrt() seems to be fine in %d to %d-1.\n", l, r
}

function _t_iCbrt(l, r,		i, t) {
	for (i = l; i < r; i++) {
		t = iCbrt(i)
		if (t * t * t > i || (t+1) * (t+1) * (t+1) <= i) {
			printf "ERROR: %d %d\n", i, t
			exit
		}
	}
	printf "iCbrt() seems to be fine in %d to %d-1.\n", l, r
}

function demo(	i, t, u) {
	for (i = 0; i < 21; i++) {
		t = sqrt(i); u = fSqrt(i)
		printf "sqrt(%d) \t%.20f\nfSqrt(%d)\t%.20f (%s (delta: %g))\n",
			i, t, i, u, _p(t == u), abs(t - u)
	}

	print "--"

	for (i = -10; i <= 10; i++) {
		t = fCbrt(i); u = fCbrt2(i)
		printf "fCbrt(%d) \t%.20f\nfCbrt2(%d)\t%.20f (%s (delta: %g))\n",
			i, t, i, u, _p(t == u), abs(t - u)
	}
}

BEGIN {
	demo()

	print "--"

	# _t_iSqrt(0, 2 ^ 32) # Maybe this will take a lot of time.
	# _t_iCbrt(0, 2 ^ 32) # Maybe this will take a lot of time.
	_t_iSqrt(0, 2 ^ 16)
	_t_iCbrt(0, 2 ^ 16)
}
