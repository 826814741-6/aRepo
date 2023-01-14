#
#	from src/sum.c
#
#	float sum1(int, float[])	to	sum1
#	float sum2(int, float[])	to	sum2
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
