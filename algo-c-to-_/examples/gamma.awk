#
#	from src/gamma.c
#
#	double loggamma(double)		to	loggamma
#	double gamma(double)		to	gamma
#	double beta(double, double)	to	beta
#

BEGIN {
	print "  x       Gamma(x)"
	for (x = -5.5; x <= 0.51; x += 1.0)
		printf "%4.1f  % .15g\n", x, gamma(x)
	for (x = 1; x <= 5.1; x += 1.0)
		printf "%4.1f  % .15g\n", x, gamma(x)
	for (x = 10; x <= 30.1; x += 5.0)
		printf "%4.1f  % .15g\n", x, gamma(x)
}
