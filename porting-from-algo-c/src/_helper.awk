#
#  _helper.awk: some helper functions
#

function abs(n) {
	if (n == 0)
		return 0
	else if (n < 0)
		return -n
	else
		return n
}
#
# > gawk 'BEGIN{ v = -0; if (v == -v && v == 0.0 && v == -0.0) print "ok" }'
# ok
# > mawk 'BEGIN{ v = -0; if (v == -v && v == 0.0 && v == -0.0) print "ok" }'
# ok
# > nawk 'BEGIN{ v = -0; if (v == -v && v == 0.0 && v == -0.0) print "ok" }'
# ok
#

function atLeastOne(n) { return n>1 ? n : 1 }

#
#  (_length(): It appears this workaround is no longer necessary.)
#
#function _length(a,	r, e) {
#	r = 0
#	for (e in a) r += 1
#	return r
#}
#
#  function f(a) { return length(a) }
#  function g(a) { return _length(a) }
#
#  BEGIN {
#      s = "1 2 3 4 5"
#      split(s, a)
#
#      print length(a)  # OK(5)
#      print f(a)       # OK(5); Previously I got the error with certain AWK.
#      print g(a)       # OK(5)
#  }
#

function concat(a,	r, i) {
	r = ""
	for (i = 1; i <= length(a); i++)
		r = r""a[i]
	return r
}

function _p(b) { return b ? "T" : "F" }

function rep(s, n,	i, r) {
	r = ""
	for (i = 0; i < n; i++) r = r s
	return r
}

function swap(a, i, j,	t) {
	t = a[i]
	a[i] = a[j]
	a[j] = t
}
