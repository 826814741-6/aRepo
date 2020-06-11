#
#	from src/dragon.c
#
#	void dragon(int, double, double, int)	to	dragon
#

from svgplot import svgPlot
from dragoncurve import dragonCurveR

def sampleWriter(pathPrefix, x, y):
    plotter = svgPlot(x, y)

    def sample(fh, order, dx, dy, sign, x0, y0):
        plotter.plotStart(fh)
        dragonCurveR(plotter, order, dx, dy, sign, x0, y0)
        plotter.plotEnd()

    def writer(order, dx, dy, sign, x0, y0):
        with open("{0}{1}.svg".format(pathPrefix, order), "w") as fh:
            sample(fh, order, dx, dy, sign, x0, y0)

    return writer

#

x, y, dx, dy = 400, 250, 200, 0
writer = sampleWriter("results/dragoncurveR-py", x, y)
for order in range(1, 11):
    writer(order, dx, dy, 1, 100, 100)

sampleWriter("results/dragoncurveR-py", x, y)(12, dx, dy, 1, 100, 100)
sampleWriter("results/dragoncurveRN-py", x, y)(12, dx, dy, -1, 70, 160)
