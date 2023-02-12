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

function _rec(x, n, r, t) {
	if (t != 0) {
		if (t % 2 == 1) r *= x
		return _rec(x*x, n, r, int(t/2))
	} else {
		return n<0 ? 1/r : r
	}
	#return t!=0 ? _rec(x*x, n, t%2==1?r*x:r, int(t/2)) : (n<0?1/r:r)
}

# in GAWK
#
# 9.1.6 Bit-Manipulation Functions
# https://www.gnu.org/software/gawk/manual/html_node/Bitwise-Functions.html
#
#function _rec(x, n, r, t) {
#	if (t != 0) {
#		if (and(t,1) == 1) r *= x
#		return _rec(x*x, n, r, rshift(t,1))
#	} else {
#		return n<0 ? 1/r : r
#	}
#	#return t!=0 ? _rec(x*x, n, and(t,1)==1?r*x:r, rshift(t,1)) : (n<0?1/r:r)
#}

function iPowR(x, n) {
	return _rec(x, n, 1, int(abs(n)))
}

function fPow(x, n) {
	return x>0 ? exp(n*log(x)) : 0
}

#

#
#	_p(b) from src/_helper.awk
#

BEGIN {
	printf "%22s%18s%18s\n",
		"2^n==iPow(2,n)", "2^n==iPowR(2,n)", "2^n==fPow(2,n)"

	for (n=-10; n<=10; n++)
		printf "%15s%18s%18s\n",
			_p(2^n==iPow(2,n)), _p(2^n==iPowR(2,n)), _p(2^n==fPow(2,n))

	printf "%15s%25s%18s\n",
		"2^n", "2^n==fPow(2,n)", "fPow(2,n)"

	for (n=-10; n<=10; n++)
		printf "%25.20f%8s%32.20f\n",
			2^n, _p(2^n==fPow(2,n)), fPow(2,n)
}
