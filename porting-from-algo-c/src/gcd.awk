#
#	from src/gcd.c
#
#	int gcd(int, int) ; recursive	to	gcdR
#	int gcd(int, int) ; loop	to	gcdL
#	int ngcd(int, int[])		to	ngcdL
#	(ngcdL				to	ngcdR)
#

function gcdR(x, y) {
	if (y == 0)
		return x
	else
		return gcdR(y, x % y)
}

function gcdL(x, y,	t) {
	while (y != 0) {
		t = x % y; x = y; y = t
	}
	return x
}

function ngcdL(a,	i, d) {
	d = a[1]
	for (i = 2; i <= length(a); i++) {
		if (d == 1) break
		d = gcdL(a[i], d)
	}
	return d
}

#
# TODO:
#
# ERROR in MAWK (not raised in NAWK/GAWK)
#
# mawk: gcd.awk: line 37: illegal reference to local variable a
# mawk: gcd.awk: line 41: type error in arg(1) in call to _iter
#
#function _iter(a, i, d) {
#	if (i > length(a) || d == 1)
#		return d
#	else
#		return _iter(a, i+1, gcdR(a[i], d))
#}
#
#function ngcdR(a) {
#	return _iter(a, 1, a[1])
#}
#
