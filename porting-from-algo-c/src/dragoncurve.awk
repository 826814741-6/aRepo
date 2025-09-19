#
#  from src/dragon.c
#
#    void dragon(int, double, double, int)  to  dragonCurve
#

#
#  drawRel, move from src/svgplot.awk
#

function rec(n, dx, dy, sign) {
	if (n == 0) {
		drawRel(dx, dy)
	} else {
		rec(n - 1, (dx - sign*dy) / 2, (dy + sign*dx) / 2, 1)
		rec(n - 1, (dx + sign*dy) / 2, (dy - sign*dx) / 2, -1)
	}
}

function dragonCurve(n, dx, dy, sign, x0, y0) {
	move(x0, y0)
	rec(n, dx, dy, sign)
}
