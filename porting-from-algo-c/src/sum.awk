#
#  from src/sum.c
#
#    float sum1(int, float[])  to  sum1
#    float sum2(int, float[])  to  sum2
#

function sum1(a, n,	r, i) {
	r = 0
	for (i = 1; i <= n; i++)
		r += a[i]
	return r
}

function sum2(a, n,	r, rest, i, t) {
	r = 0; rest = 0
	for (i = 1; i <= n; i++) {
		rest += a[i]
		t = r
		r += rest
		t -= r
		rest += t
	}
	return r
}

#

#
#  _p(b) from _helper.awk
#

BEGIN {
	n = 10000
	for (i = 1; i <= n; i++) a[i] = 1/n

	printf "1.0 == %s : %s\n", "sum1(a, n)", _p(1 == sum1(a, n))
	printf "1.0 == %s : %s\n", "sum2(a, n)", _p(1 == sum2(a, n))
}
