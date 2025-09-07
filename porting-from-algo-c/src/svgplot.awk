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

BEGIN {
	_OUTPUT_PATH = ""
	_WIDTH = 0
	_HEIGHT = 0
}

function init(path, w, h) {
	_OUTPUT_PATH = path
	_WIDTH = w
	_HEIGHT = h
}

function header() {
	printf "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\"" \
	       " width=\"%d\" height=\"%d\">\n", _WIDTH, _HEIGHT > _OUTPUT_PATH
}

function pathStart() {
	printf "<path d=\"" > _OUTPUT_PATH
}

function pathEnd(closePath) {
	printf "%s\" fill=\"none\" stroke=\"black\" />\n",
	       closePath > _OUTPUT_PATH
}

function footer() {
	print "</svg>" > _OUTPUT_PATH
}

function move(x, y) {
	printf "M %g %g ", x, _HEIGHT - y > _OUTPUT_PATH
}

function moveRel(x, y) {
	printf "m %g %g ", x, -y > _OUTPUT_PATH
}

function draw(x, y) {
	printf "L %g %g ", x, _HEIGHT - y > _OUTPUT_PATH
}

function drawRel(x, y) {
	printf "l %g %g ", x, -y > _OUTPUT_PATH
}
