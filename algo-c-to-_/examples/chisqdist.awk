#
#	from src/chi2.c
#
#	double pNormal(double)		to	pNormal
#	double qNormal(double)		to	qNormal
#	double qChiSquare(int, double)	to	qChiSquare
#	double pChiSquare(int, double)	to	pChiSquare
#

BEGIN {
	print "-------- pChiSquare(df, chiSq)"
	printf "chiSq  %-16s %-16s %-16s %-16s\n",
		"df=1", "df=2", "df=5", "df=20"

	for (i = 0; i < 20; i++) {
		chiSq = 0.5 * i;
		printf "%4.1f %16.14f %16.14f %16.14f %16.14f\n",
			chiSq,
			pChiSquare(1, chiSq),
			pChiSquare(2, chiSq),
			pChiSquare(5, chiSq),
			pChiSquare(20, chiSq)
	}
}
