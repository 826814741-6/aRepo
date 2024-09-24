#
#	from src/svgplot.c
#
#	void plot_start(int, int)		to	svgPlot; .plotStart, .pathStart
#	void plot_end(int)			to	svgPlot; .plotEnd, .pathEnd
#	void move(double, double)		to	svgPlot; .move
#	void move_rel(double, double)		to	svgPlot; .moveRel
#	void draw(double, double)		to	svgPlot; .draw
#	void draw_rel(double, double)		to	svgPlot; .drawRel
#

import sys

def _header(x, y):
    return """<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="{0}" height="{1}">
""".format(x, y)

def _pathStart():
    return """<path d=\""""

def _pathEnd(isClosePath):
    return """{0}" fill="none" stroke="black" />
""".format("Z" if isClosePath else "")

def _footer():
    return """</svg>
"""

class svgPlot:
    def __init__(self, width, height):
        self.fh = None
        self.W = width
        self.H = height

    def plotStart(self, fileHandler=None):
        self.fh = fileHandler if fileHandler != None else sys.stdout
        self.fh.write(_header(self.W, self.H))

    def plotEnd(self):
        self.fh.write(_footer())
        self.fh = None

    def pathStart(self):
        self.fh.write(_pathStart())

    def pathEnd(self, isClosePath=False):
        self.fh.write(_pathEnd(isClosePath))

    def move(self, x, y):
        self.fh.write("M {0:g} {1:g} ".format(x, self.H - y))

    def moveRel(self, x, y):
        self.fh.write("m {0:g} {1:g} ".format(x, -y))

    def draw(self, x, y):
        self.fh.write("L {0:g} {1:g} ".format(x, self.H - y))

    def drawRel(self, x, y):
        self.fh.write("l {0:g} {1:g} ".format(x, -y))

def _demo(path):
    import math

    def sample(plotter, fh):
        plotter.plotStart(fh)
        plotter.pathStart()
        for i in range(5):
            theta = 2 * math.pi * i / 5
            x, y = 150 + 140 * math.cos(theta), 150 + 140 * math.sin(theta)
            if i == 0:
                plotter.move(x, y)
            else:
                plotter.draw(x, y)
        plotter.pathEnd(True)
        plotter.plotEnd()

    with open(path, "w") as fh:
        plotter = svgPlot(300, 300)
        sample(plotter, fh)

if __name__ == "__main__":
    _demo("results/svgplot-py.svg")
