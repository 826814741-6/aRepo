#
#	from src/ccurve.c
#
#	void c(int, double, double)	to	ccurve
#

from svgplot import svgPlot
from ccurve import ccurve

def sampleWriter(pathPrefix):
    plotter = svgPlot(400, 250)

    def sample(fh, order):
        plotter.plotStart(fh)
        plotter.move(100, 200)
        ccurve(plotter, order, 200, 0)
        plotter.plotEnd()

    def writer(order):
        with open("{0}{1}.svg".format(pathPrefix, order), "w") as fh:
            sample(fh, order)

    return writer

writer = sampleWriter("results/ccurve-py")
for order in range(1, 11):
    writer(order)
