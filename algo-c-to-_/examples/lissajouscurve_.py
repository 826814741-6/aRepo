#
#	from src/lissaj.c
#
#	a part of main		to	lissajousCurve
#

from svgplot import svgPlot
from lissajouscurve import lissajousCurve

def sampleWriter(path, n, offset):
    plotter = svgPlot((n + offset) * 2, (n + offset) * 2)

    def sample(fh):
        plotter.plotStart(fh)
        lissajousCurve(plotter, n, offset)
        plotter.plotEnd()

    def writer():
        with open(path, "w") as fh:
            sample(fh)

    return writer

#

n, offset = 300, 10
writer = sampleWriter("results/lissajouscurve-py.svg", n, offset)
writer()
