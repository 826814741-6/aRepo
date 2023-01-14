#
#	from src/change.c
#
#	int change(int, int)		to	changeR
#	int change1(int, int)		to	changeL
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
