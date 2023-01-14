#
#	from src/e.c
#
#	long double ee(void)	to	e
#

BEGIN {
	t = e()
	printf "%.14f\n%.20f\n", t, t
}
