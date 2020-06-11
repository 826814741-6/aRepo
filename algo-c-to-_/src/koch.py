#
#	from src/koch.c
#
#	void koch(void)		to	koch
#

from math import sin, cos, pi

def koch(plotter, d, a, dmax=3):
    def iter(d, a):
        if d > dmax:
            d /= 3
            iter(d, a)
            a += 1
            iter(d, a)
            a += 4
            iter(d, a)
            a += 1
            iter(d, a)
            d *= 3
        else:
            plotter.drawRel(d * cos((a % 6) * pi / 3), d * sin((a % 6) * pi / 3))

    iter(d, a)
