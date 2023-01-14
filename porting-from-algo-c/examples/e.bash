#
#	from src/e.c
#
#	long double ee(void)	to	e
#

. "src/e.bash" || exit

printf "%s\n" $(e 1000000000000000000)
