#
#  from src/koch.c
#
#    void koch(void)  to  koch
#

#
#  drawRel, PI from src/svgplot.awk
#

function koch(d, a, dmax) {
	if (d > dmax) {
		d = d / 3
		koch(d, a, dmax)
		a = a + 1
		koch(d, a, dmax)
		a = a + 4
		koch(d, a, dmax)
		a = a + 1
		koch(d, a, dmax)
		d = d * 3
	} else
		drawRel(d * cos((a % 6) * PI / 3), d * sin((a % 6) * PI / 3))
	end
}
