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

	PI = atan2(0, -1)
}
#
# > gawk 'BEGIN{ v = -0; printf "%f, %g, ", v, v; print v }'
# -0.000000, -0, 0
# > mawk 'BEGIN{ v = -0; printf "%f, %g, ", v, v; print v }'
# -0.000000, -0, 0
# > nawk 'BEGIN{ v = -0; printf "%f, %g, ", v, v; print v }'
# 0.000000, 0, 0
#
# Note:
# In NAWK, the value -0 seems to be treated as 0, so "atan2(0,-0)", which is
# one of the idioms to get PI, returns 0.
# (see: setfval() in https://github.com/onetrueawk/awk/blob/master/tran.c)
#
# > gawk 'BEGIN{ print atan2(0,-0), atan2(0.0,-0.0), atan2(0,-1) }'
# 3.14159 3.14159 3.14159
# > mawk 'BEGIN{ print atan2(0,-0), atan2(0.0,-0.0), atan2(0,-1) }'
# 3.14159 3.14159 3.14159
# > nawk 'BEGIN{ print atan2(0,-0), atan2(0.0,-0.0), atan2(0,-1) }'
# 0 0 3.14159
#

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
