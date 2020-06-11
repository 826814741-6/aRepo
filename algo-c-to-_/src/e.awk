#
#	from src/e.c
#
#	long double ee(void)	to	e
#

function e(	r, a, n, prev) {
	r = 0; a = 1; n = 1
	do {
		prev = r; r += a; a /= n; n++
	} while (r != prev)
	return r
}
