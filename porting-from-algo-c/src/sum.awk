#
#  from src/sum.c
#
#    float sum1(int, float[])  to  sum1
#    float sum2(int, float[])  to  sum2
#

function sum1(a,	r, len, i) {
	r = 0; len = length(a)
	for (i = 1; i <= len; i++)
		r += a[i]
	return r
}

function sum2(a,	r, rest, len, i, t) {
	r = 0; rest = 0; len = length(a)
	for (i = 1; i <= len; i++) {
		rest += a[i]
		t = r
		r += rest
		t -= r
		rest += t
	}
	return r
}

#

function fmt(b) { return b ? "T" : "F" }

function run(n,	i, a, r1, r2) {
	for (i = 1; i <= n; i++) a[i] = 1/n

	r1 = sum1(a)
	r2 = sum2(a)

	printf "[%6d] 1 == sum1(): %s (%a)\n", n, fmt(1 == r1), r1  # see
	printf "[%6d] 1 == sum2(): %s (%a)\n", n, fmt(1 == r2), r2  # bottom
}

BEGIN {
	run(10)
	run(100)
	run(1000)
	run(10000)
	run(100000)
}

#
# In mawk, you will probably get the following error caused by "%a":
#
# > mawk: run time error: improper conversion(number 3) in printf("[%6d] 1 == sum1(): %s (%a)
# > ...
#
# so if you want to run this script in mawk, please replace "%a" with
# something appropriate to your preference.
#
