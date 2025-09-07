#
#  from src/treecurv.c
#
#    void tree(int, double, double)  to  treeCurve
#

function treeCurve(n, len, angle, factor, turn,	x, y) {
	x = len * sin(angle)
	y = len * cos(angle)

	drawRel(x, y)

	if (n > 0) {
		treeCurve(n-1, len * factor, angle + turn, factor, turn)
		treeCurve(n-1, len * factor, angle - turn, factor, turn)
	}

	moveRel(-x, -y)
}
