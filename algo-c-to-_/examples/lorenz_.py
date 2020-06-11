#
#	from src/lorenz.c
#
#	a part of main		to	lorenzAttractor
#

from svgplot import svgPlot
from lorenz import lorenzAttractor

sigma, rho, beta, n = 10, 28, 8 / 3, 4000
x, y, a1, a2, a3, a4 = 400, 460, 0.01, 10, 200, 40

plotter = svgPlot(x, y)
with open("results/lorenz-py.svg", "w") as fh:
    plotter.plotStart(fh)
    lorenzAttractor(plotter, sigma, rho, beta, n, a1, a2, a3, a4)
    plotter.plotEnd()
