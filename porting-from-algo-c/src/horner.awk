#
#	from src/horner.c
#
#	double horner(int, double a[], double)		to	horner
#

#
#	a = {number, number, number, number, number, ...}
#
#	[1] + [2] * x + [3] * x^2 + [4] * x^3 + [5] * x^4 + ...
#
#	... + [5] * x^4 + [4] * x^3 + [3] * x^2 + [2] * x^1 + [1]
#

#
#	_length(a) from _helper.awk
#

function horner(a, x,	len, p, i) {
	len = _length(a) # In nawk and gawk, you can use the built-in 'length' here; see _helper.awk

	if (len == 0) {
		print "ERROR: 'a' must be a table that contains at least one element."
		return
	}

	p = a[len]
	for (i = len - 1; i >= 1; i--)
		p = p * x + a[i]

	return p
}
