#
#	from src/treecurv.c
#
#	void tree(int, double, double)		to	treeCurve
#

import math

def treeCurve(plotter, n, length, angle, factor, turn):
    x, y = length * math.sin(angle), length * math.cos(angle)

    plotter.drawRel(x, y)

    if n > 0:
        treeCurve(plotter, n-1, length * factor, angle + turn, factor, turn)
        treeCurve(plotter, n-1, length * factor, angle - turn, factor, turn)

    plotter.moveRel(-x, -y)

def _demo(path, n):
    import svgplot

    with open(path, "w") as fh:
        plotter = svgplot.svgPlot(400, 350)
        plotter.plotStart(fh)
        plotter.pathStart()
        plotter.move(200, 0)
        treeCurve(plotter, n, 100, 0, 0.7, 0.5)
        plotter.pathEnd()
        plotter.plotEnd()

if __name__ == "__main__":
    _demo("results/treecurve-py.svg", 10)
