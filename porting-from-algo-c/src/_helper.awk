function abs(n) { return n<0 ? -n : n }

function atLeastOne(n) { return n>1 ? n : 1 }

function decrement(n) { return n - 1 }

function increment(n) { return n + 1 }

#
#  _length(): filling the gap of length() between mawk and others(nawk,gawk)
#
function _length(a,	r, e) {
	r = 0
	for (e in a) r += 1
	return r
}
#
#  function f(a) { return length(a) }
#  function g(a) { return _length(a) }
#
#  BEGIN {
#      s = "1 2 3 4 5"
#      split(s, a)
#
#      print length(a)  # OK(5) in nawk, mawk, gawk
#      print f(a)       # OK(5) in nawk, gawk / ERROR in mawk(*)
#      print g(a)       # OK(5) in nawk, mawk, gawk
#  }
#
#  *) ERROR message in mawk
#  mawk: ... : type error in arg(1) in call to f
#

function concat(a,	r, i) {
	r = ""
	for (i = 1; i <= _length(a); i++)
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
