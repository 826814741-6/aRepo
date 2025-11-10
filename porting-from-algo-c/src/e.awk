#
#  from src/e.c
#
#    long double ee(void)  to  e, efmt
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

function run(	t, r) {
	print "# -- e()"

	t = e()

	printf "   %%e : %e\n", t
	printf "   %%f : %f\n", t
	printf "   %%g : %g\n", t
	printf "   %%a : %a\n", t  # see bottom
	printf "%%.20e : %.20e\n", t
	printf "%%.20f : %.20f\n", t
	printf "%%.20g : %.20g\n", t

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
# In mawk, you will probably get the following error caused by "%a":
#
# > mawk: run time error: improper conversion(number 2) in printf("   %%a : %a
# > ...
#
# so if you want to run this script in mawk, please comment out the above line.
#
