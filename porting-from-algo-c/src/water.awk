#
#	from src/water.c
#
#	a part of main		to	isMeasurable
#

function _gcd(x, y,	t) {
	while (y != 0) {
		t = x % y; x = y; y = t
	}
	return x
}

function isMeasurable(a, b, v) {
	return (v <= a || v <= b) && (v % _gcd(a, b)) == 0
}
