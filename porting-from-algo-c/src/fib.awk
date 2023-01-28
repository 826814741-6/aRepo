#
#	from src/fib.c
#
#	int fib1(int)		to	fib1
#	int fib2(int)		to	fib2
#	a part of main		to	fib3
#	fib3			to	fib4
#

function fib1(n) {
	return int((((1 + sqrt(5)) / 2) ^ n) / sqrt(5) + 0.5)
}

function fib2(n,	a, b, c, x, y, p, q, r) {
	a = 1; b = 1; c = 0; x = 1; y = 0; n--
	while (n > 0) {
		if (n % 2 != 0) {
			p = x; q = y
			x = a * p + b * q; y = b * p + c * q
		}
		p = a; q = b; r = c
		a = p * p + q * q
		b = q * (p + r)
		c = q * q + r * r
		n = int(n/2)
	}
	return x
}

function fib3(n,	a, b, c, t) {
	a = 1; b = 0; c = 1
	while (c < n) {
		t = a + b; b = a; a = t; c++
	}
	return a
}

function _iter(n, a, b, c) {
	if (c < n)
		return _iter(n, a + b, a, c + 1)
	else
		return a
}

function fib4(n) {
	return _iter(n, 1, 0, 1)
}

#

BEGIN {
	for (i=1; i<=11; i++) printf " %d", fib1(i)
	print
	for (i=1; i<=11; i++) printf " %d", fib2(i)
	print
	for (i=1; i<=11; i++) printf " %d", fib3(i)
	print
	for (i=1; i<=11; i++) printf " %d", fib4(i)
	print
}
