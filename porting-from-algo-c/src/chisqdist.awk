#
#	from src/chi2.c
#
#	double pNormal(double)		to	pNormal
#	double qNormal(double)		to	qNormal
#	double qChiSquare(int, double)	to	qChiSquare
#	double pChiSquare(int, double)	to	pChiSquare
#

BEGIN {
	PI = 3.14159265358979323846264 # from src/chi2.c
}

function pNormal(z,	p, prev, t, i) {
	t = z * exp(-0.5 * z * z) / sqrt(2 * PI)
	p = t
	for (i = 3; i < 200; i += 2) {
		prev = p
		t *= (z*z) / i
		p += t
		if (p == prev) return 0.5 + p
	}
	return z > 0
}

function qNormal(z) {
	return 1 - pNormal(z)
}

function _loopQChiSq(df, chiSq, k0, t0,		k, t, u) {
	t = t0
	u = t0
	for (k = k0; k < df; k += 2) {
		t *= chiSq / k
		u += t
	}
	return u
}

function qChiSquare(df, chiSq) {
	if (df % 2 == 1) {
		if (df == 1) return 2 * qNormal(sqrt(chiSq))
		return 2 * (qNormal(sqrt(chiSq)) + \
			_loopQChiSq(df, chiSq, 3, sqrt(chiSq) * exp(-0.5*chiSq) / sqrt(2*PI)))
	} else {
		return _loopQChiSq(df, chiSq, 2, exp(-0.5 * chiSq))
	}
}

function pChiSquare(df, chiSq) {
	return 1 - qChiSquare(df, chiSq)
}
