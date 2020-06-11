#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

#
#	rep(s,n) from src/_helper.awk
#

BEGIN {
	xl = 1; xr = 10; xlength = 10
	yl = 0; yr = 19
	w1 = 4;	w2 = 4

	padding = rep(" ", w1 + 2)
	border = rep(rep("-", w2), xlength)
	fmt1 = sprintf("%%%dd |", w1)
	fmt2 = sprintf("%%%dd", w2)

	printf padding
	for (i=xl; i<=xr; i++) printf fmt2, i
	print "\n" padding border

	for (j=yl; j<=yr; j++) {
		printf fmt1, j * 10
		for (i=xl; i<=xr; i++) printf fmt2, phi(j * 10 + i)
		print
	}
}
