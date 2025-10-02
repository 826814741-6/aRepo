#
#  from src/whrnd.c
#
#    void init_rnd(int, int, int)  to  init
#    double rnd(void)              to  rnd
#
#  from src/monte.c
#
#    void monte1(int)              to  piA
#    void monte2(int)              to  piB
#    void monte3(int)              to  piC
#
#  src/randperm.c
#
#    void shuffle(int, int [])     to  shuffle
#    void randperm(int, int [])    to  randPerm
#

BEGIN {
	_X = 0
	_Y = 0
	_Z = 0

	_PI = atan2(0, -1)
}

function init(x, y, z) {
	_X = x
	_Y = y
	_Z = z
}

function rnd(	r) {
	_X = 171 * (_X % 177) -  2 * int(_X / 177)
	_Y = 172 * (_Y % 176) - 35 * int(_Y / 176)
	_Z = 170 * (_Z % 178) - 63 * int(_Z / 178)
	if (_X < 0) _X = _X + 30269
	if (_Y < 0) _Y = _Y + 30307
	if (_Z < 0) _Z = _Z + 30323
	r = _X / 30269 + _Y / 30307 + _Z / 30323
	while (r >= 1) r = r - 1
	return r
}

#

function piA(n, fmt,	hit, _, x, y, t) {
	hit = 0

	for (_ = 0; _ < n; _++) {
		x = rnd(); y = rnd()
		if (x*x + y*y < 1) hit += 1
	}

	t = hit / n

	return sprintf(fmt, 4 * t, 4 * sqrt(t * (1 - t) / (n - 1)))
}

function piB(n, fmt,	sum, sumSq, _, x, y, t) {
	sum = 0; sumSq = 0

	for (_ = 0; _ < n; _++) {
		x = rnd()
		y = sqrt(1 - x * x)
		sum += y; sumSq += y * y
	}

	t = sum / n

	return sprintf(fmt, 4 * t, 4 * sqrt((sumSq / n - t * t) / (n - 1)))
}

#
#  abs(n) from _helper.awk
#

function piC(n, fmt,	a, x, sum, _, t) {
	a = (sqrt(5) - 1) / 2

	x = 0; sum = 0
	for (_ = 0; _ < n; _++) {
		x += a
		if (x >= 1) x -= 1
		sum += sqrt(1 - x * x)
	}

	t = 4 * sum / n

	return sprintf(fmt, t, abs(_PI - t))
}

#

#
#  swap(a, i, j) from _helper.awk
#

function shuffle(a,	i, j) {
	for (i = length(a) - 1; 0 < i; i--) {
		j = int((i + 1) * rnd())
		swap(a, i, j)
	}
}

function randPerm(a, n,	i) {
	for (i = 0; i < n; i++) {
		a[i] = i + 1
	}
	shuffle(a)
}

#

function pRnd(col, row,	i, j) {
	for (i = 0; i < row; i++) {
		for (j = 0; j < col; j++) printf "%10.7f", rnd()
		print
	}
}

function pPi(n,	fmt) {
	fmt = "%6.5f (%6.5f)"
	print piA(n, fmt), piB(n, fmt), piC(n, fmt)
}

function pRndPerm(col, row, fmt,	a, i, j, offset) {
	split("", a)
	randPerm(a, col * row)
	for (i = 0; i < row; i++) {
		offset = i * col
		for (j = 0; j < col; j++) printf fmt, a[j + offset]
		print
	}
}

BEGIN {
	print "-------- whrnd: 12345, 23451, 13579"
	init(12345, 23451, 13579)
	pRnd(8, 20)

	print "-------- whrnd: 1, 2, 3"
	init(1, 2, 3)
	pRnd(8, 20)

	print "-------- whrnd: 12345, 23451, 13579"
	init(12345, 23451, 13579)
	pRnd(8, 20)

	print "-------- piA,piB,piC in whrnd: 12345, 23451, 13579"
	init(12345, 23451, 13579)
	pPi(10)
	pPi(100)
	pPi(1000)
	pPi(10000)
	pPi(100000)

	print "-------- randPerm in whrnd: 12345, 23451, 13579"
	init(12345, 23451, 13579)
	pRndPerm(20, 20, "%4d")
}
