#
#	from src/lissaj.c
#
#	a part of main		to	lissajousCurve
#

import math

def _stepX(n, offset, a):
    return n + offset + n * math.cos(a)

def _stepY(n, offset, a):
    return n + offset + n * math.sin(a)

def lissajousCurve(plotter, n, offset):
    plotter.move(_stepX(n, offset, 0), _stepY(n, offset, 0))
    for i in range(1, 361):
        plotter.draw(_stepX(n, offset, 3 * (math.pi / 180) * i),
                     _stepY(n, offset, 5 * (math.pi / 180) * i))

def _demo(path):
    import svgplot

    with open(path, "w") as fh:
        size, offset = 300, 10
        plotter = svgplot.svgPlot((size + offset) * 2, (size + offset) * 2)
        plotter.plotStart(fh)
        plotter.pathStart()
        lissajousCurve(plotter, size, offset)
        plotter.pathEnd()
        plotter.plotEnd()

if __name__ == "__main__":
    _demo("results/lissajouscurve-py.svg")
