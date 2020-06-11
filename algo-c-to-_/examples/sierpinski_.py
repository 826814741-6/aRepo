#
#	from src/sierpin.c
#
#	void urd(int)		to	sierpinski; urd
#	void lur(int)		to	sierpinski; lur
#	void dlu(int)		to	sierpinski; dlu
#	void rdl(int)		to	sierpinski; rdl
#

from svgplot import svgPlot
from sierpinski import sierpinski

def sampleWriter(pathPrefix, n, offset):
    plotter = svgPlot(n + offset, n + offset)

    def sample(fh, order):
        plotter.plotStart(fh)
        sierpinski(plotter, order, n)
        plotter.plotEnd(True)

    def writer(order):
        with open("{0}{1}.svg".format(pathPrefix, order), "w") as fh:
            sample(fh, order)

    return writer

writer = sampleWriter("results/sierpinski-py", 600, 2)
for order in range(1, 7):
    writer(order)
