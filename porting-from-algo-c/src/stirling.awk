#
#  from src/stirling.c
#
#    int Stirling1(int, int)  to  stirling1
#    int Stirling2(int, int)  to  stirling2
#

function stirling1(n, k) {
	if (k < 1 || k > n) return 0
	if (k == n) return 1
	return (n-1) * stirling1(n-1, k) + stirling1(n-1, k-1)
}

function stirling2(n, k) {
	if (k < 1 || k > n) return 0
	if (k == 1 || k == n) return 1
	return k * stirling2(n-1, k) + stirling2(n-1, k-1)
}

#

BEGIN {
	xl = 0; xr = 10; xlength = 11
	yl = 0; yr = 10
	w1 = 3; w2 = 8

	padding = rep(" ", w1 + 2)
	border = rep(rep("-", w2), xlength)
	fmt1 = sprintf("%%%dd |", w1)
	fmt2 = sprintf("%%%dd", w2)

	print "-------- Stirling numbers of the first kind:"
	printf padding
	for (n=xl; n<=xr; n++) printf fmt2, n
	print "\n" padding border

	for (k=yl; k<=yr; k++) {
		printf fmt1, k
		for (n=xl; n<=k; n++) printf fmt2, stirling1(k, n)
		print
	}

	print "-------- Stirling numbers of the second kind:"
	printf padding
	for (n=xl; n<=xr; n++) printf fmt2, n
	print "\n" padding border

	for (k=yl; k<=yr; k++) {
		printf fmt1, k
		for (n=xl; n<=k; n++) printf fmt2, stirling2(k, n)
		print
	}
}
