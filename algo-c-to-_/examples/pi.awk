#
#	from src/pi1.c
#
#	long double pi(void)	to	machinLike
#
#	from src/pi2.c
#
#	a part of main		to	gaussLegendre
#

function _p1(n) { printf "%.14f %.20f\n", n, n }
function _p2(m, n) { printf "%.14f %.20f (%d)\n", n, n, m }

BEGIN {
	print "-------- machinLike:"
	_p1(machinLike())

	print "-------- gaussLegendre n:"
	for (i = 1; i <= 3; i++) _p2(i, gaussLegendre(i))
}
