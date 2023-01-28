#
#	from src/hypot.c
#
#	double hypot0(double, double)		to	hypot0
#	double hypot1(double, double)		to	hypot1
#	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
#

#
#	abs(n) from _helper.awk
#

function hypot0(x, y) {
	return sqrt(x * x + y * y)
}

function hypot1(x, y) {
	if (x == 0) return abs(y)
	if (y == 0) return abs(x)
	return abs(x) < abs(y) ? \
		abs(y) * sqrt(1 + (x/y) * (x/y)) : \
		abs(x) * sqrt(1 + (y/x) * (y/x))
}

function hypot2(x, y,	a, b, t, i) {
	a = abs(x); b = abs(y)
	if (a < b) { t = a; a = b; b = t }
	if (b == 0) return a
	for (i = 0; i < 3; i++) {
		t = (b/a)*(b/a) / (4 + (b/a)*(b/a))
		a = a + 2 * a * t; b = b * t
	}
	return a
}

#

BEGIN {
	printf "%.14f %.20f\n", hypot0(1,2), hypot0(1,2)
	printf "%.14f %.20f\n", hypot1(1,2), hypot1(1,2)
	printf "%.14f %.20f\n", hypot2(1,2), hypot2(1,2)

	printf "%.14f %.20f\n", hypot0(2^511,2^512), hypot0(2^511,2^512)
	printf "%.14f %.20f\n", hypot1(2^511,2^512), hypot1(2^511,2^512)
	printf "%.14f %.20f\n", hypot2(2^511,2^512), hypot2(2^511,2^512)
}
