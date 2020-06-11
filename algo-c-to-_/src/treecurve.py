#
#	from src/treecurv.c
#
#	void tree(int, double, double)		to	treecurve
#

from math import sin, cos

def treecurve(plotter, n, length, angle, factor, turn):
    x, y = length * sin(angle), length * cos(angle)
    plotter.drawRel(x, y)
    if n > 0:
        treecurve(plotter, n-1, length * factor, angle + turn, factor, turn)
        treecurve(plotter, n-1, length * factor, angle - turn, factor, turn)
    plotter.moveRel(-x, -y)
