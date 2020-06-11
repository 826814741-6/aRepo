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
		if (and(t,1) == 1) r *= x
		x *= x
		t = rshift(t,1)
	}
	return n<0 ? 1/r : r
}

function _iter(x, n, r, t) {
#	if (t != 0) {
#		if (and(t,1) == 1) r *= x
#		return _iter(x*x, n, r, rshift(t,1))
#	} else {
#		return n<0 ? 1/r : r
#	}
	return t!=0 ? _iter(x*x, n, and(t,1)==1?r*x:r, rshift(t,1)) : (n<0?1/r:r)
}

function iPowR(x, n) {
	return _iter(x, n, 1, int(abs(n)))
}

function fPow(x, n) {
	return x>0 ? exp(n*log(x)) : 0
}
