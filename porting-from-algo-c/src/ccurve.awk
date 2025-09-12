#
#  from src/ccurve.c
#
#    void c(int, double, double)  to  cCurve
#

#
#  drawRel from src/svgplot.awk
#

function cCurve(i, x, y) {
	if (i == 0) {
		drawRel(x, y)
	} else {
		cCurve(i - 1, (x + y) / 2, (y - x) / 2)
		cCurve(i - 1, (x - y) / 2, (y + x) / 2)
	}
}
