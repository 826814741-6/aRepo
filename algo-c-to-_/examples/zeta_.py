#
#	from src/zeta.c
#
#	double zeta(double)	to	riemannZeta
#

from zeta import riemannZeta

zeta = riemannZeta()

for x in range(-4, 1):
    print("zeta({0:2}) : {1:.15f}".format(x, zeta(x)))

print()

for x in range(2, 21):
    print("zeta({0:2}) : {1:.15f}".format(x, zeta(x)))
