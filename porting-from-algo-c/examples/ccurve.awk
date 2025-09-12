#
#  from src/ccurve.c
#
#    void c(int, double, double)  to  cCurve
#

#
#  init, header, footer, pathStart, pathEnd, move from src/svgplot.awk
#

function sample(path, n) {
	init(path, 400, 250)

	header()
	pathStart()
	move(100, 200)
	cCurve(n, 200, 0)
	pathEnd("")
	footer()
}

BEGIN {
	sample("results/ccurve-awk.svg", 10)
}
