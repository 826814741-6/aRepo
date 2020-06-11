#
#	from src/normal.c
#
#	double pNormal(double)		to	pNormal
#	double qNormal(double)		to	qNormal
#

BEGIN {
	printf "%-3s %-16s\n", "z", "pNormal(z)"
	for (i = 0; i <= 20; i++) {
		z = 0.2 * i
		printf "%3.1f %16.14f\n", z, pNormal(z)
	}
}
