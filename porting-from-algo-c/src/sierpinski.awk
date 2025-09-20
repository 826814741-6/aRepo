#
#  from src/sierpin.c
#
#    void urd(int)                to  sierpinski; urd
#    void lur(int)                to  sierpinski; lur
#    void dlu(int)                to  sierpinski; dlu
#    void rdl(int)                to  sierpinski; rdl
#

#
#  move, drawRel from src/svgplot.awk
#

function sierpinski(order, size,	h, _) {
	h = 1; size = int(size / 6)

	for (_ = 1; _ < order; _++)
		h = 3 * h / (6 + h)

	h = h * size

	move(h + 1, 1)
	urd(order, h)
	drawRel(h, h)
	lur(order, h)
	drawRel(-h, h)
	dlu(order, h)
	drawRel(-h, -h)
	rdl(order, h)
	drawRel(h, -h)
}

# UpRightDown
function urd(i, h) {
	if (i == 0) return
	urd(i - 1, h)
	drawRel(h, h)
	lur(i - 1, h)
	drawRel(2 * h, 0)
	rdl(i - 1, h)
	drawRel(h, -h)
	urd(i - 1, h)
}

# LeftUpRight
function lur(i, h) {
	if (i == 0) return
	lur(i - 1, h)
	drawRel(-h, h)
	dlu(i - 1, h)
	drawRel(0, 2 * h)
	urd(i - 1, h)
	drawRel(h, h)
	lur(i - 1, h)
}

# DownLeftUp
function dlu(i, h) {
	if (i == 0) return
	dlu(i - 1, h)
	drawRel(-h, -h)
	rdl(i - 1, h)
	drawRel(-2 * h, 0)
	lur(i - 1, h)
	drawRel(-h, h)
	dlu(i - 1, h)
}

# RightDownLeft
function rdl(i, h) {
	if (i == 0) return
	rdl(i - 1, h)
	drawRel(h, -h)
	urd(i - 1, h)
	drawRel(0, -2 * h)
	dlu(i - 1, h)
	drawRel(-h, -h)
	rdl(i - 1, h)
}
