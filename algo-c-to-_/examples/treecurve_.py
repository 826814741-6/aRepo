#
#	from src/treecurv.c
#
#	void tree(int, double, double)		to	treecurve
#

from svgplot import svgPlot
from treecurve import treecurve

def sampleWriter(pathPrefix):
    plotter = svgPlot(400, 350)

    def sample(fh, order):
        plotter.plotStart(fh)
        plotter.move(200, 0)
        treecurve(plotter, order, 100, 0, 0.7, 0.5)
        plotter.plotEnd()

    def writer(order):
        with open("{0}{1}.svg".format(pathPrefix, order), "w") as fh:
            sample(fh, order)

    return writer

writer = sampleWriter("results/treecurve-py")
for order in range(1, 11):
    writer(order)
