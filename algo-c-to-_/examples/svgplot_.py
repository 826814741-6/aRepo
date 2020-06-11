#
#	from src/svgplot.c
#
#	void plot_start(int, int)		to	svgPlot; .plotStart
#	void plot_end(int)			to	svgPlot; .plotEnd
#	void move(double, double)		to	svgPlot; .move
#	void move_rel(double, double)		to	svgPlot; .moveRel
#	void draw(double, double)		to	svgPlot; .draw
#	void draw_rel(double, double)		to	svgPlot; .drawRel
#

from svgplot import svgPlot
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

plotter = svgPlot(300, 300)
with open("results/svgplot-py.svg", "w") as fh:
    sample(plotter, fh)
