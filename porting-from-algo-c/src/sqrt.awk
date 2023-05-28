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
		r = int(r / 2); t = t * 2
	}
	do {
		r = t; t = int((int(x / t) + t) / 2)
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

BEGIN {
	for (i = 0; i < 21; i++)
		printf "sqrt(%d) \t%.20f\nfSqrt(%d)\t%.20f (%s)\n",
			i, sqrt(i), i, fSqrt(i), _p(sqrt(i) == fSqrt(i))

	print

	# _t_iSqrt(0, 2 ^ 32) # Maybe this will take a lot of time. (*)
	_t_iSqrt(0, 2 ^ 16)
}

#
#	*) a list of elapsed time - running _t_iSqrt(0, n) on my old cheap laptop
#
#	in luajit, n == 1<<28 (2^28):
#
#		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
#		...
#		iSqrt() seems to be fine in 0 to 268435456-1.
#
#		real    0m36.307s
#		user    0m35.889s
#		sys     0m0.015s
#
#	in luajit, n == 1<<32 (2^32):
#
#		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
#		...
#		iSqrt() seems to be fine in 0 to 4294967296-1.
#
#		real    10m0.827s
#		user    10m0.906s
#		sys     0m0.096s
#
#	in lua, n == 1<<28 (2^28)
#
#		$ time LUA_PATH=src/?.lua lua example/sqrt.lua
#		...
#		iSqrt() seems to be fine in 0 to 268435456-1.
#
#		real    4m50.528s
#		user    4m50.730s
#		sys     0m0.021s
#
