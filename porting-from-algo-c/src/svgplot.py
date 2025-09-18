#
#  from src/svgplot.c
#
#    void plot_start(int, int)      to  SvgPlot; .plotStart, .pathStart
#    void plot_end(int)             to  SvgPlot; .plotEnd, .pathEnd
#    void move(double, double)      to  SvgPlot; .move
#    void move_rel(double, double)  to  SvgPlot; .moveRel
#    void draw(double, double)      to  SvgPlot; .draw
#    void draw_rel(double, double)  to  SvgPlot; .drawRel
#

import sys

def _header(x, y):
    return f"""<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="{x}" height="{y}">
"""

def _pathStart():
    return """<path d=\""""

def _pathEnd(isClosePath):
    return f"""{"Z" if isClosePath else ""}" fill="none" stroke="black" />
"""

def _footer():
    return """</svg>
"""

class SvgPlot:
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
        self.fh.write(f"M {x:g} {self.H - y:g} ")

    def moveRel(self, x, y):
        self.fh.write(f"m {x:g} {-y:g} ")

    def draw(self, x, y):
        self.fh.write(f"L {x:g} {self.H - y:g} ")

    def drawRel(self, x, y):
        self.fh.write(f"l {x:g} {-y:g} ")

def _demo(path):
    import math

    def sample(plotter, fh, n, offset):
        plotter.plotStart(fh)
        plotter.pathStart()
        for i in range(5):
            theta = 2 * math.pi * i / 5
            x, y = n/2 + (n/2 - offset) * math.cos(theta), n/2 + (n/2 - offset) * math.sin(theta)
            if i == 0:
                plotter.move(x, y)
            else:
                plotter.draw(x, y)
        plotter.pathEnd(True)
        plotter.plotEnd()

    with open(path, "w") as fh:
        size, offset = 300, 10
        plotter = SvgPlot(size, size)
        sample(plotter, fh, size, offset)

if __name__ == "__main__":
    _demo("results/svgplot-py.svg")
