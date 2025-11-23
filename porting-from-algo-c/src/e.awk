#
#  from src/e.c
#
#    long double ee(void)  to  e, rec, efmt
#

function e(	r, a, n, prev) {
	r = 0; a = 1; n = 1
	do {
		prev = r; r += a; a /= n; n++
	} while (r != prev)
	return r
}

function rec(r, a, n, prev) {
	if (r != prev) {
		return rec(r + a, a / n, n + 1, r)
	}
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

function run(	e1, e2, r) {
	print "# -- e()"

	e1 = e()
	e2 = rec(0, 1, 1, 1)

	if (e1 != e2) {
		printf "Error: e() != rec()\n"
		return
	}

	printf "   %%e : %e\n", e1
	printf "   %%f : %f\n", e1
	printf "   %%g : %g\n", e1
	printf "   %%a : %a\n", e1  # see bottom
	printf "%%.20e : %.20e\n", e1
	printf "%%.20f : %.20f\n", e1
	printf "%%.20g : %.20g\n", e1

	print "# -- efmt(\"%.21f,%d\")"

	split(efmt("%.21f,%d"), r, ",")

	printf "   %%e : %e (%d)\n", r[1], r[2]
	printf "   %%f : %f\n", r[1]
	printf "   %%g : %g\n", r[1]
	printf "   %%a : %a\n", r[1]  # see bottom
	printf "%%.20e : %.20e\n", r[1]
	printf "%%.20f : %.20f\n", r[1]
	printf "%%.20g : %.20g\n", r[1]

	print "# -- efmt(\"%f,%d\")"

	split(efmt("%f,%d"), r, ",")

	printf "   %%e : %e (%d)\n", r[1], r[2]
	printf "   %%f : %f\n", r[1]
	printf "   %%g : %g\n", r[1]
	printf "   %%a : %a\n", r[1]  # see bottom
	printf "%%.20e : %.20e\n", r[1]
	printf "%%.20f : %.20f\n", r[1]
	printf "%%.20g : %.20g\n", r[1]
}

BEGIN {
	run()
}

#
# In certain AWK, the "a" specifier of printf may be unsupported.
#
