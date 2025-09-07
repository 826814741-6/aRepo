#
#  from src/change.c
#
#    int change(int, int)   to  changeR
#    int change1(int, int)  to  changeL
#

function changeR(n, k,	r) {
	if (n < 0) return 0

	r = 1 + int(n/5) + changeR(n - 10, 10)
	if (k >= 50) { r += changeR(n - 50, 50) }
	if (k >= 100) { r += changeR(n - 100, 100) }

	return r
}

function changeL(n,	r, t, u, i, j) {
	r = 0
	for (i = int(n/100); i >= 0; i--) {
		t = n - 100 * i
		for (j = int(t/50); j >= 0; j--) {
			u = t - 50 * j
			r += (1 + int(u/5) - int(u/10)) * (1 + int(u/10))
		}
	}
	return r
}

#

BEGIN {
	for (i = 0; i <= 500; i += 5) {
		a = changeR(i, i)
		b = changeL(i)

		if (a != b) {
			printf "changeR(i,i) != changeL(i) (i:%d, changeR:%d, changeL:%d)\n", i, a, b
			exit
		}

		printf "%4d %8d\n", i, a
	}
}
