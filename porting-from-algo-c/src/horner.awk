#
#  from src/horner.c
#
#    double horner(int, double a[], double)  to  horner
#

#
#  a = {number, number, number, number, number, ...}
#
#  [1] + [2] * x + [3] * x^2 + [4] * x^3 + [5] * x^4 + ...
#
#  ... + [5] * x^4 + [4] * x^3 + [3] * x^2 + [2] * x^1 + [1]
#

#
#  _length(a) from _helper.awk
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

#

#
#  _length(a) from _helper.awk
#

function fmt(a,		len, r, i) {
	len = _length(a) # In nawk and gawk, you can use the built-in 'length' here; see _helper.awk

	if (len == 0) {
		print "ERROR: 'a' must be a table that contains at least one element."
		return
	}

	r = "f(x) = "a[len]" * x^"len-1
	for (i = len-1; i >= 3; i--)
		r = r" + "a[i]" * x^"i-1
	if (len > 1)
		r = r" + "a[2]" * x"
	r = r" + "a[1]

	return r
}

BEGIN {
	split("1 2 3 4 5", a)
	print fmt(a)
	printf "f(%d) = %d\n", 2, horner(a, 2)
	printf "f(%d) = %d\n", 11, horner(a, 11)
	printf "f(%d) = %d\n", 121, horner(a, 121)
}
