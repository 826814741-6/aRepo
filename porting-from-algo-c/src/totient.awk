#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

function phi(x,		t, d) {
	t = x
	if (x % 2 == 0) {
		t = int(t/2)
		do {
			x = int(x/2)
		} while (x % 2 == 0)
	}

	d = 3
	while (int(x/d) >= d) {
		if (x % d == 0) {
			t = int(t/d) * (d - 1)
			do {
				x = int(x/d)
			} while (x % d == 0)
		}
		d += 2
	}

	if (x > 1) {
		t = int(t/x) * (x - 1)
	}

	return t
}

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
