#
#	from src/koch.c
#
#	void koch(void)		to	koch
#

from svgplot import svgPlot
from koch import koch

def sampleWriter(path):
    plotter = svgPlot(1200, 360)

    def sample(fh):
        plotter.plotStart(fh)
        plotter.move(0, 0)
        koch(plotter, 1200, 0, 3)
        plotter.plotEnd()

    def writer():
        with open(path, "w") as fh:
            sample(fh)

    return writer

writer = sampleWriter("results/koch-py.svg")
writer()
