#
#	from src/hilbert.c
#
#	void rul(int)		to	hilbert; rul
#	void dlu(int)		to	hilbert; dlu
#	void ldr(int)		to	hilbert; ldr
#	void urd(int)		to	hilbert; urd
#

from svgplot import svgPlot
from hilbert import hilbert

def sampleWriter(pathPrefix, n, offset):
    plotter = svgPlot(n + offset, n + offset)

    def sample(fh, order):
        plotter.plotStart(fh)
        hilbert(plotter, order, n, offset)
        plotter.plotEnd()

    def writer(order):
        with open("{0}{1}.svg".format(pathPrefix, order), "w") as fh:
            sample(fh, order)

    return writer

writer = sampleWriter("results/hilbert-py", 600, 3)
for order in range(1, 9):
    writer(order)
