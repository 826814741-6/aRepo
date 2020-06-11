#
#	from src/e.c
#
#	long double ee(void)	to	e
#

from e import e

r, n = e()

print("{0:.14f}\n{1:.20f}\n{2} ({3})".format(r, r, r, n))
