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

import sys

class epsPlot:
    def __init__(self, x, y):
        self.fh = None
        self.header = """%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: 0 0 {0} {1}
""".format(x, y)

    def plotStart(self, fileHandler=None):
        self.fh = fileHandler != None and fileHandler or sys.stdout

        self.fh.write(self.header)
        self.fh.write("newpath")
        self.fh.write("\n")

    def plotEnd(self, isClosePath):
        if isClosePath:
            self.fh.write("closepath")
        self.fh.write("\n")
        self.fh.write("stroke")
        self.fh.write("\n")

        self.fh = None

    def move(self, x, y):
        self.fh.write("{0:g} {1:g} moveto".format(x, y))
        self.fh.write("\n")

    def moveRel(self, x, y):
        self.fh.write("{0:g} {1:g} rmoveto".format(x, y))
        self.fh.write("\n")

    def draw(self, x, y):
        self.fh.write("{0:g} {1:g} lineto".format(x, y))
        self.fh.write("\n")

    def drawRel(self, x, y):
        self.fh.write("{0:g} {1:g} rlineto".format(x, y))
        self.fh.write("\n")
