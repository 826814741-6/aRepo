#
#	from src/pi1.c
#
#	long double pi(void)	to	machinLike
#
#	from src/pi2.c
#
#	a part of main		to	gaussLegendre
#
#	from https://en.wikipedia.org/wiki/Leibniz_formula_for_%CF%80
#
#	a part of article	to	leibniz
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

function leibniz(n,	r, sign, x, i) {
	r = 0; sign = 1; x = 1
	for (i = 0; i < n; i++) {
		r += sign / x; sign *= -1; x += 2
	}
	return r * 4
}

#

function _p1(n) { printf "%.14f %.20f\n", n, n }
function _p2(m, n) { printf "%.14f %.20f (%d)\n", n, n, m }

BEGIN {
	print "-------- machinLike:"
	_p1(machinLike())

	print "-------- gaussLegendre n:"
	_p2(1, gaussLegendre(1))
	_p2(2, gaussLegendre(2))
	_p2(3, gaussLegendre(3))

	print "-------- leibniz n:"
	_p2(10000, leibniz(10000))
	_p2(100000, leibniz(100000))
	_p2(1000000, leibniz(1000000))
}
