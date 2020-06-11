#
#	from src/power.c
#
#	double ipower(double, int)	to	iPow
#	iPow				to	iPowR
#	double power(double, double)	to	fPow
#

#
#	abs(n) from _helper.awk
#

function iPow(x, n,	r, t) {
	r = 1
	t = int(abs(n))
	while (t != 0) {
		if (t % 2 == 1) r *= x
		x *= x
		t = int(t/2)
	}
	return n<0 ? 1/r : r
}

function _iter(x, n, r, t) {
#	if (t != 0) {
#		if (t % 2 == 1) r *= x
#		return _iter(x*x, n, r, int(t/2))
#	} else {
#		return n<0 ? 1/r : r
#	}
	return t!=0 ? _iter(x*x, n, t%2==1?r*x:r, int(t/2)) : (n<0?1/r:r)
}

function iPowR(x, n) {
	return _iter(x, n, 1, int(abs(n)))
}

function fPow(x, n) {
	return x>0 ? exp(n*log(x)) : 0
}
