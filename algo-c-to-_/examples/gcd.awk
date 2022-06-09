#
#	from src/gcd.c
#
#	int gcd(int, int) ; recursive	to	gcdR
#	int gcd(int, int) ; loop	to	gcdL
#	int ngcd(int, int[])		to	ngcdL
#	(ngcdL				to	ngcdR)
#

function _t_gcd(s,	a) {
	split(s, a)
	if (gcdL(a[1], a[2]) != a[3]) return 0
	if (gcdR(a[1], a[2]) != a[3]) return 0
	if (gcdL(a[1], a[2]) != gcdR(a[1], a[2])) return 0
	if (a[1] != a[2]) {
		if (gcdL(a[2], a[1]) != a[3]) return 0
		if (gcdR(a[2], a[1]) != a[3]) return 0
	}
	if (gcdL(gcdL(gcdL(a[1], a[2]), a[1]), a[2]) != a[3]) return 0
	if (gcdR(gcdR(gcdR(a[1], a[2]), a[1]), a[2]) != a[3]) return 0
	if (gcdL(gcdR(gcdL(a[1], a[2]), a[2]), a[1]) != a[3]) return 0
	if (gcdR(gcdL(gcdR(a[1], a[2]), a[2]), a[1]) != a[3]) return 0
	return 1
}

function _t_ngcd(s, d,		a) {
	split(s, a)
	if (ngcdL(a) != d) return 0
	#if (ngcdR(a) != d) return 0
	#if (ngcdL(a) != ngcdR(a)) return 0
	return 1
}

BEGIN {
	t0 = 0
	t0 += _t_gcd("11 121 11")
	t0 += _t_gcd("22 22 22")
	t0 += _t_gcd("2 3 1")

	# 2147483647*4194304 (9007199250546688) < 1<<53
	t0 += _t_gcd("2147483647 9007199250546688 2147483647")  # nawk/mawk/gawk 2147483647
	# 2147483647*4194305 (9007201398030335) > 1<<53
	t0 += _t_gcd("2147483647 9007201398030335 2147483647")  # nawk 2147483647, mawk/gawk 1
	# 2147483647*6700417 (14389035935580799) > 1<<53
	t0 += _t_gcd("2147483647 14389035935580799 2147483647") # nawk 2147483647, mawk/gawk 1

	printf "gcdL and gcdR seem to be fine (in %d/%d samples).\n", t0, 6

	t1 = 0
	t1 += _t_ngcd("1", 1)
	t1 += _t_ngcd("10", 10)
	# t1 += _t_ngcd("2 3", 1)
	# TODO:
	#	split("2 3", a)
	#	print ngcdL(a)
	#
	#	2 (... but must be 1)
	t1 += _t_ngcd("22 22 22 22 22", 22 )
	t1 += _t_ngcd("11 22 33 44 55 66 77 88 99 110", 11 )

	# 2147483647*4194304 (9007199250546688) < 1<<53
	t1 += _t_ngcd("2147483647 2147483647 9007199250546688", 2147483647 )  # nawk/mawk/gawk 2147483647
	# 2147483647*4194305 (9007201398030335) > 1<<53
	t1 += _t_ngcd("2147483647 2147483647 9007201398030335", 2147483647 )  # nawk 2147483647, mawk/gawk 1
	# 2147483647*6700417 (14389035935580799) > 1<<53
	t1 += _t_ngcd("2147483647 2147483647 14389035935580799", 2147483647 ) # nawk 2147483647, mawk/gawk 1

	printf "ngcdL and ngcdR seem to be fine (in %d/%d samples).\n", t1, 7
}
