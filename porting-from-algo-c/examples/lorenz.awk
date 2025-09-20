#
#  from src/lorenz.c
#
#    a part of main  to  lorenzAttractor
#

#
#  init, header, footer, pathStart, pathEnd from src/svgplot.awk
#

function sample(path) {
	init(path, 400, 460)

	header()
	pathStart()
	lorenzAttractor(10, 28, 8 / 3, 4000, 0.01, 10, 200, 40)
	pathEnd("")
	footer()
}

BEGIN {
	sample("results/lorenz-awk.svg")
}
