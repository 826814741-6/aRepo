#
#  from src/fib.c
#
#    int fib1(int)   to  fib1
#    int fib2(int)   to  fib2
#    a part of main  to  fib3
#    fib3            to  fib4
#

function fib1(n) {
	return int((((1 + sqrt(5)) / 2) ^ n) / sqrt(5) + 0.5)
}

function fib2(n,	a, b, c, x, y, p, q, r) {
	if (n <= 0) return 0
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
	a = 0; b = 1; c = 1
	while (c <= n) {
		t = a + b; a = b; b = t; c++
	}
	return a
}

function _rec(n, a, b, c) {
	if (c <= n)
		return _rec(n, b, a + b, c + 1)
	else
		return a
}

function fib4(n) {
	return _rec(n, 0, 1, 1)
}

#

BEGIN {
	for (i=0; i<=10; i++) printf "%4d", i
	print
	for (i=0; i<=10; i++) printf "%4d", fib1(i)
	print
	for (i=0; i<=10; i++) printf "%4d", fib2(i)
	print
	for (i=0; i<=10; i++) printf "%4d", fib3(i)
	print
	for (i=0; i<=10; i++) printf "%4d", fib4(i)
	print
}
