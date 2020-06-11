#
#	from src/pi1.c
#
#	long double pi(void)	to	machinLike
#
#	from src/pi2.c
#
#	a part of main		to	gaussLegendre
#

function machinLike(	p, k, t, prev) {
	p = 0; k = 1; t = 16 / 5
	do {
		prev = p; p += t / k; k += 2; t /= -5*5
	} while (p != prev)

	k = 1; t = 4 / 239
	do {
		prev = p; p -= t / k; k += 2; t /= -239*239
	} while (p != prev)

	return p
}

function gaussLegendre(n,	a, b, t, u, prev, i) {
	a = 1; b = 1 / sqrt(2); t = 1; u = 4
	for (i = 0; i < n; i++) {
		prev = a
		a = (a + b) / 2; b = sqrt(prev * b)
		t -= u * (a - prev) * (a - prev); u *= 2
	}
	return (a + b) * (a + b) / t
}
