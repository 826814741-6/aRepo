#
#  from src/lissaj.c
#
#    a part of main  to  lissajousCurve
#

function _stepX(n, offset, a) {
	return n + offset + n * cos(a)
}

function _stepY(n, offset, a) {
	return n + offset + n * sin(a)
}

#
#  draw, move, PI from src/svgplot.awk
#

function lissajousCurve(n, offset,	i) {
	move(_stepX(n, offset, 0), _stepY(n, offset, 0))
	for (i = 1; i <= 360; i++) {
		draw(_stepX(n, offset, 3 * (PI / 180) * i),
		     _stepY(n, offset, 5 * (PI / 180) * i))
	}
}
