#
#	from src/combinat.c
#
#	int comb(int, int)				to	combinationR
#	unsigned long combination(int, int)		to	combination
#

function combinationR(n, k) {
	if (k == 0 || k == n) return 1
	if (k == 1) return n
	return combinationR(n - 1, k - 1) + combinationR(n - 1, k)
}

function combination(n, k,	a, i, j) {
	if (n - k < k) k = n - k

	if (k == 0) return 1
	if (k == 1) return n

	for (i = 1; i < k; i++)
		a[i] = i + 2

	for (i = 3; i <= n - k + 1; i++) {
		a[0] = i
		for (j = 1; j < k; j++) {
			a[j] += a[j - 1]
		}
	}

	return a[k - 1]
}
