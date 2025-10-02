#
#  from src/sierpin.c
#
#    void urd(int)  to  sierpinski; urd
#    void lur(int)  to  sierpinski; lur
#    void dlu(int)  to  sierpinski; dlu
#    void rdl(int)  to  sierpinski; rdl
#

#
#  init, header, footer, pathStart, pathEnd from src/svgplot.awk
#

function sample(path, n, size, offset) {
	init(path, size + offset, size + offset)

	header()
	pathStart()
	sierpinski(n, size, offset)
	pathEnd("")
	footer()
}

function run(pathPrefix,	size, offset, n) {
	size = 600; offset = 2
	for (n = 1; n <= 6; n++)
		sample(pathPrefix "-" n "-awk.svg", n, size, offset)
}

BEGIN {
	run("results/sierpinski")
}
