#
#	from src/treecurv.c
#
#	void tree(int, double, double)		to	treeCurve
#

function sample(path, n) {
	init(path, 400, 350)

	header()
	pathStart()
	move(200, 0)
	treeCurve(n, 100, 0, 0.7, 0.5)
	pathEnd("")
	footer()
}

BEGIN {
	sample("results/treecurve-awk.svg", 10)
}
