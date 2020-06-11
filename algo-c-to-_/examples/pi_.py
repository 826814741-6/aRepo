#
#	from src/pi1.c
#
#	long double pi(void)	to	machinLike
#
#	from src/pi2.c
#
#	a part of main		to	gaussLegendre
#

from pi import machinLike, gaussLegendre

def p1(n):
    print("{0:.14f} {1:.20f}".format(n, n))

def p2(m, n):
    print("{0:.14f} {1:.20f} ({2})".format(n, n, m))

print("-------- machinLike:")
p1(machinLike())

print("-------- gaussLegendre n:")
for i in range(1, 4):
    p2(i, gaussLegendre(i))
