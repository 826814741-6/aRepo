#
#  from src/hilbert.c
#
#    void rul(int)  to  hilbert; rul
#    void dlu(int)  to  hilbert; dlu
#    void ldr(int)  to  hilbert; ldr
#    void urd(int)  to  hilbert; urd
#

#
#  init, header, footer, pathStart, pathEnd from src/svgplot.awk
#

function sample(path, n, size, offset) {
	init(path, size + offset, size + offset)

	header()
	pathStart()
	hilbert(n, size, offset)
	pathEnd("")
	footer()
}

function run(pathPrefix,	size, offset, n) {
	size = 600; offset = 3
	for (n = 1; n <= 8; n++)
		sample(pathPrefix "-" n "-awk.svg", n, size, offset)
}

BEGIN {
	run("results/hilbert")
}
