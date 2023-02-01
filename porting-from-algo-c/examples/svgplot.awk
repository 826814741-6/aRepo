#
#	from src/svgplot.c
#
#	void plot_start(int, int)		to	header, pathStart
#	void plot_end(int)			to	footer, pathEnd
#	void move(double, double)		to	move
#	void move_rel(double, double)		to	moveRel
#	void draw(double, double)		to	draw
#	void draw_rel(double, double)		to	drawRel
#

function sample(path,	pi, theta, i, x, y) {
	init(path, 300, 300)

	pi = atan2(0,-0)

	header()
	pathStart()
	for (i = 0; i < 5; i++) {
		theta = 2 * pi * i / 5
		x = 150 + 140 * cos(theta)
		y = 150 + 140 * sin(theta)
		if (i == 0)
			move(x, y)
		else
			draw(x, y)
	}
	pathEnd("Z")
	footer()
}

BEGIN {
	sample("results/svgplot-awk.svg")
}
