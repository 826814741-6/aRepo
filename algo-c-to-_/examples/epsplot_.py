#
#	from src/epsplot.c
#
#	void plot_start(int, int)		to	epsPlot; .plotStart
#	void plot_end(int)			to	epsPlot; .plotEnd
#	void move(double, double)		to	epsPlot; .move
#	void move_rel(double, double)		to	epsPlot; .moveRel
#	void draw(double, double)		to	epsPlot; .draw
#	void draw_rel(double, double)		to	epsPlot; .drawRel
#

from epsplot import epsPlot
import math

def sample(plotter, fh):
    plotter.plotStart(fh) # .plotStart() write to io.stdout
    for i in range(5):
        theta = 2 * math.pi * i / 5
        x, y = 150 + 140 * math.cos(theta), 150 + 140 * math.sin(theta)
        if i == 0:
            plotter.move(x, y)
        else:
            plotter.draw(x, y)
    plotter.plotEnd(True)

plotter = epsPlot(300, 300)
with open("results/epsplot-py.eps", "w") as fh:
    sample(plotter, fh)
