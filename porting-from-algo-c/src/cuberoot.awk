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

BEGIN {
	for (i = -10; i <= 10; i++) {
		t = fCbrt(i); u = fCbrt2(i)
		printf "%3d %.14f %18.14f %3s (delta: %g)\n",
			i, t, u, _p(t == u), abs(t-u)
	}

	print

	# _t_iCbrt(0, 2 ^ 32) # Maybe this will take a lot of time.
}
