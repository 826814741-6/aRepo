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
#	_p(b) from src/_helper.awk
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

	# _t_iSqrt(0, lshift(1, 32)) # Maybe this will take a lot of time.
	_t_iSqrt(0, lshift(1, 16))
}

#
#	*) Please choose a number depending on the purpose and situation.
#
#	e.g. a list of elapsed time - running _t_iSqrt(0, n) on my old cheap laptop
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
