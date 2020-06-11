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

import sys

class svgPlot:
    def __init__(self, x, y):
        self.fh = None
        self.Y = y
        self.header = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="{0}" height="{1}">'.format(x, y)
        self.footer = "</svg>"

    def plotStart(self, fileHandler=None):
        self.fh = fileHandler != None and fileHandler or sys.stdout

        self.fh.write(self.header)
        self.fh.write("\n")
        self.fh.write('<path d="')

    def plotEnd(self, isClosePath=False):
        if isClosePath:
            self.fh.write("Z")
        self.fh.write('" fill="none" stroke="black" />')
        self.fh.write("\n")
        self.fh.write(self.footer)
        self.fh.write("\n")

        self.fh = None

    def move(self, x, y):
        self.fh.write("M {0:g} {1:g} ".format(x, self.Y - y))

    def moveRel(self, x, y):
        self.fh.write("m {0:g} {1:g} ".format(x, -y))

    def draw(self, x, y):
        self.fh.write("L {0:g} {1:g} ".format(x, self.Y - y))

    def drawRel(self, x, y):
        self.fh.write("l {0:g} {1:g} ".format(x, -y))
