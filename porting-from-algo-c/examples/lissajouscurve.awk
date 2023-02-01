#
#	from src/lissaj.c
#
#	a part of main		to	lissajousCurve
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
