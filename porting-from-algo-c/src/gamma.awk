#
#	from src/gamma.c
#
#	double loggamma(double)		to	loggamma
#	double gamma(double)		to	gamma
#	double beta(double, double)	to	beta
#

BEGIN {
	__PI = 3.14159265358979324
	__LOG_2PI = 1.83787706640934548
	__N = 8

	# __B0 = 1
	# __B1 = -1.0 / 2.0
	__B2 = 1.0 / 6.0
	__B4 = -1.0 / 30.0
	__B6 = 1.0 / 42.0
	__B8 = -1.0 / 30.0
	__B10 = 5.0 / 66.0
	__B12 = -691.0 / 2730.0
	__B14 = 7.0 / 6.0
	__B16 = -3617.0 / 510.0
}

function loggamma(x,	v, w) {
	v = 1
	while (x < __N) { v *= x; x++ }
	w = 1 / (x * x)
	return ((((((((__B16 / (16 * 15)) * w + (__B14 / (14 * 13))) * w \
		+ (__B12 / (12 * 11))) * w + (__B10 / (10 * 9))) * w \
		+ (__B8 / (8 * 7))) * w + (__B6 / (6 * 5))) * w \
		+ (__B4 / (4 * 3))) * w + (__B2 / (2 * 1))) / x \
		+ 0.5 * __LOG_2PI - log(v) - x + (x - 0.5) * log(x)
}

function gamma(x) {
	if (x < 0)
		return __PI / (sin(__PI * x) * exp(loggamma(1 - x)))
	else
		return exp(loggamma(x))
}

function beta(x, y) {
	return exp(loggamma(x) + loggamma(y) - loggamma(x + y))
}

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
