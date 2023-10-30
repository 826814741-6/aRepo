#
#	from src/e.c
#
#	long double ee(void)	to	e, efmt
#

function e(	r, a, n, prev) {
	r = 0; a = 1; n = 1
	do {
		prev = r; r += a; a /= n; n++
	} while (r != prev)
	return r
}

function efmt(fmt,	r, a, n, prev) {
	r = 0; a = 1; n = 1
	do {
		prev = r; r += a; a /= n; n++
	} while (r != prev)
	return sprintf(fmt, r, n - 1)
}

#

BEGIN {
	print "# -- e()"

	t = e()

	printf "   %%e : %e\n", t
	printf "   %%f : %f\n", t
	printf "   %%g : %g\n", t
	printf "   %%a : %a\n", t
	printf "%%.20e : %.20e\n", t
	printf "%%.20e : %.20f\n", t
	printf "%%.20e : %.20g\n", t

	print "# -- efmt(\"%.21f,%d\")"

	split(efmt("%.21f,%d"), _r, ",")

	printf "   %%e : %e (%d)\n", _r[1], _r[2]
	printf "   %%f : %f\n", _r[1]
	printf "   %%g : %g\n", _r[1]
	printf "   %%a : %a\n", _r[1]
	printf "%%.20e : %.20e\n", _r[1]
	printf "%%.20e : %.20f\n", _r[1]
	printf "%%.20e : %.20g\n", _r[1]

	print "# -- efmt(\"%f,%d\")"

	split(efmt("%f,%d"), _r, ",")

	printf "   %%e : %e (%d)\n", _r[1], _r[2]
	printf "   %%f : %f\n", _r[1]
	printf "   %%g : %g\n", _r[1]
	printf "   %%a : %a\n", _r[1]
	printf "%%.20e : %.20e\n", _r[1]
	printf "%%.20e : %.20f\n", _r[1]
	printf "%%.20e : %.20g\n", _r[1]
}
