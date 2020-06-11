#
#	from src/dragon2.c
#
#	a part of main				to	dragonCurve
#

from svgplot import svgPlot
from dragoncurve import dragonCurve

def sampleWriter(pathPrefix, x, y):
    plotter = svgPlot(x, y)

    def sample(fh, order, x0, y0):
        plotter.plotStart(fh)
        dragonCurve(plotter, order, x0, y0)
        plotter.plotEnd()

    def writer(order, x0, y0):
        with open("{0}{1}.svg".format(pathPrefix, order), "w") as fh:
            sample(fh, order, x0, y0)

    return writer

#

x, y, x0, y0 = 510, 350, 120, 120
writer = sampleWriter("results/dragoncurve-py", x, y)
for order in range(1, 11):
    writer(order, x0, y0)
