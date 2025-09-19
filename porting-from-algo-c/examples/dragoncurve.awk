#
#  from src/dragon.c
#
#    void dragon(int, double, double, int)  to  dragonCurve
#

#
#  init, header, footer, pathStart, pathEnd from src/svgplot.awk
#

function sample(path, n, sign, x0, y0) {
	init(path, 400, 250)

	header()
	pathStart()
	dragonCurve(n, 200, 0, sign, x0, y0)
	pathEnd("")
	footer()
}

BEGIN {
	sample("results/dragoncurve-awk-A.svg", 10, 1, 100, 100)
	sample("results/dragoncurve-awk-B.svg", 12, -1, 70, 160)
}
