#
#	from src/lissaj.c
#
#	a part of main		to	lissajousCurve
#

from math import pi, sin, cos

def lissajousCurve(plotter, n, offset):
    stepX = lambda m: n + offset + n * cos(m)
    stepY = lambda m: n + offset + n * sin(m)

    plotter.move(stepX(0), stepY(0))
    for i in range(1, 361):
        plotter.draw(stepX(3 * (pi / 180) * i), stepY(5 * (pi / 180) * i))
