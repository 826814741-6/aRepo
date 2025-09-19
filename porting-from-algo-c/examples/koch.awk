#
#  from src/koch.c
#
#    void koch(void)  to  koch
#

#
#  init, header, footer, pathStart, pathEnd, move from src/svgplot.awk
#

BEGIN {
	init("results/koch-awk.svg", 1200, 360)

	header()
	pathStart()
	move(0, 0)
	koch(1200, 0, 3)
	pathEnd("")
	footer()
}
