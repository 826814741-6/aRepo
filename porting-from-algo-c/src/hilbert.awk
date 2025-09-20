#
#  from src/hilbert.c
#
#    void rul(int)  to  hilbert; rul
#    void dlu(int)  to  hilbert; dlu
#    void ldr(int)  to  hilbert; ldr
#    void urd(int)  to  hilbert; urd
#

#
#  move, drawRel from src/svgplot.awk
#

function hilbert(order, size, offset,	_, h) {
	h = size

	for (_ = 1; _ < order; _++)
		h = h / (2 + h / size)

	move(1 + int(offset / 2), 1)
	rul(order, h)
}

# RightUpLeft
function rul(i, h) {
	if (i == 0) return
	urd(i - 1, h)
	drawRel(h, 0)
	rul(i - 1, h)
	drawRel(0, h)
	rul(i - 1, h)
	drawRel(-h, 0)
	dlu(i - 1, h)
}

# DownLeftUp
function dlu(i, h) {
	if (i == 0) return
	ldr(i - 1, h)
	drawRel(0, -h)
	dlu(i - 1, h)
	drawRel(-h, 0)
	dlu(i - 1, h)
	drawRel(0, h)
	rul(i - 1, h)
}

# LeftDownRight
function ldr(i, h) {
	if (i == 0) return
	dlu(i - 1, h)
	drawRel(-h, 0)
	ldr(i - 1, h)
	drawRel(0, -h)
	ldr(i - 1, h)
	drawRel(h, 0)
	urd(i - 1, h)
}

# UpRightDown
function urd(i, h) {
	if (i == 0) return
	rul(i - 1, h)
	drawRel(0, h)
	urd(i - 1, h)
	drawRel(h, 0)
	urd(i - 1, h)
	drawRel(0, -h)
	ldr(i - 1, h)
}
