#
#  from src/lissaj.c
#
#    a part of main  to  lissajousCurve
#

#
#  init, header, footer, pathStart, pathEnd from src/svgplot.awk
#

function sample(path, n, offset) {
	init(path, (n + offset) * 2, (n + offset) * 2)

	header()
	pathStart()
	lissajousCurve(n, offset)
	pathEnd("")
	footer()
}

BEGIN {
	sample("results/lissajouscurve-awk.svg", 300, 10)
}
