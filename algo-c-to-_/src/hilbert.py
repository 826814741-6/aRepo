#
#	from src/hilbert.c
#
#	void rul(int)		to	hilbert; rul
#	void dlu(int)		to	hilbert; dlu
#	void ldr(int)		to	hilbert; ldr
#	void urd(int)		to	hilbert; urd
#

def hilbert(plotter, order, n, offset):
    def rul(i): # RightUpLeft
        if i == 0:
            return
        urd(i - 1)
        plotter.drawRel(h, 0)
        rul(i - 1)
        plotter.drawRel(0, h)
        rul(i - 1)
        plotter.drawRel(-h, 0)
        dlu(i - 1)

    def dlu(i): # DownLeftUp
        if i == 0:
            return
        ldr(i - 1)
        plotter.drawRel(0, -h)
        dlu(i - 1)
        plotter.drawRel(-h, 0)
        dlu(i - 1)
        plotter.drawRel(0, h)
        rul(i - 1)

    def ldr(i): # LeftDownRight
        if i == 0:
            return
        dlu(i - 1)
        plotter.drawRel(-h, 0)
        ldr(i - 1)
        plotter.drawRel(0, -h)
        ldr(i - 1)
        plotter.drawRel(h, 0)
        urd(i - 1)

    def urd(i): # UpRightDown
        if i == 0:
            return
        rul(i - 1)
        plotter.drawRel(0, h)
        urd(i - 1)
        plotter.drawRel(h, 0)
        urd(i - 1)
        plotter.drawRel(0, -h)
        ldr(i - 1)

    h = n
    for _ in range(1, order):
        h /= 2 + h / n

    plotter.move(1 + offset // 2, 1)
    rul(order)
