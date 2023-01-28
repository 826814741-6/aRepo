#
#	from src/mccarthy.c
#
#	int McCarthy(int)	to	mccarthy91
#

function mccarthy91(x) {
	if (x > 100)
		return x - 10
	else
		return mccarthy91(mccarthy91(x + 11))
}

#

function _t_mccarthy91(l, r,	i, t) {
	for (i = l; i <= r; i++) {
		t = mccarthy91(i)
		if (t != 91) {
			printf "ERROR: %d %d\n", i, t
			exit
		}
	}
	printf "mccarthy91 seems to be 91 in %d to %d\n", l, r
}

BEGIN {
	_t_mccarthy91(-(2 ^ 10), 100)

	print "... and in 101 to 110 are:"

	for (i=101; i<=110; i++) printf "%4d:%d", i, mccarthy91(i)
	print
}
