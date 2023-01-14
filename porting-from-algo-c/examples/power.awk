#
#	from src/power.c
#
#	double ipower(double, int)	to	iPow
#	iPow				to	iPowR
#	double power(double, double)	to	fPow
#

#
#	_p(b) from src/_helper.awk
#

BEGIN {
	printf "%22s%18s%18s\n",
		"2^n==iPow(2,n)", "2^n==iPowR(2,n)", "2^n==fPow(2,n)"

	for (n=-10; n<=10; n++)
		printf "%15s%18s%18s\n",
			_p(2^n==iPow(2,n)), _p(2^n==iPowR(2,n)), _p(2^n==fPow(2,n))

	printf "%15s%25s%18s\n",
		"2^n", "2^n==fPow(2,n)", "fPow(2,n)"

	for (n=-10; n<=10; n++)
		printf "%25.20f%8s%32.20f\n",
			2^n, _p(2^n==fPow(2,n)), fPow(2,n)
}
