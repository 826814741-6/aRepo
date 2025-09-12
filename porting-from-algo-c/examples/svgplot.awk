#
#  from src/svgplot.c
#
#    void plot_start(int, int)      to  header, pathStart
#    void plot_end(int)             to  footer, pathEnd
#    void move(double, double)      to  move
#    void move_rel(double, double)  to  moveRel
#    void draw(double, double)      to  draw
#    void draw_rel(double, double)  to  drawRel
#

#
#  init, header, footer, pathStart, pathEnd, draw, move, PI from src/svgplot.awk
#

function sample(path, size, offset,	theta, i, x, y) {
	init(path, size, size)

	header()
	pathStart()
	for (i = 0; i < 5; i++) {
		theta = 2 * PI * i / 5
		x = size / 2 + (size / 2 - offset) * cos(theta)
		y = size / 2 + (size / 2 - offset) * sin(theta)
		if (i == 0)
			move(x, y)
		else
			draw(x, y)
	}
	pathEnd("Z")
	footer()
}

BEGIN {
	sample("results/svgplot-awk.svg", 300, 10)
}
