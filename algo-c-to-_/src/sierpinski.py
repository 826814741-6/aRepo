#
#	from src/sierpin.c
#
#	void urd(int)		to	sierpinski; urd
#	void lur(int)		to	sierpinski; lur
#	void dlu(int)		to	sierpinski; dlu
#	void rdl(int)		to	sierpinski; rdl
#

def sierpinski(plotter, order, n):
    def urd(i): # UpRightDown
        if i == 0:
            return
        urd(i - 1)
        plotter.drawRel(h, h)
        lur(i - 1)
        plotter.drawRel(2 * h, 0)
        rdl(i - 1)
        plotter.drawRel(h, -h)
        urd(i - 1)

    def lur(i): # LeftUpRight
        if i == 0:
            return
        lur(i - 1)
        plotter.drawRel(-h, h)
        dlu(i - 1)
        plotter.drawRel(0, 2 * h)
        urd(i - 1)
        plotter.drawRel(h, h)
        lur(i - 1)

    def dlu(i): # DownLeftUp
        if i == 0:
            return
        dlu(i - 1)
        plotter.drawRel(-h, -h)
        rdl(i - 1)
        plotter.drawRel(-2 * h, 0)
        lur(i - 1)
        plotter.drawRel(-h, h)
        dlu(i - 1)

    def rdl(i): # RightDownLeft
        if i == 0:
            return
        rdl(i - 1)
        plotter.drawRel(h, -h)
        urd(i - 1)
        plotter.drawRel(0, -2 * h)
        dlu(i - 1)
        plotter.drawRel(-h, -h)
        rdl(i - 1)

    h, n = 1, n // 6
    for _ in range(1, order):
        h = 3 * h / (6 + h)
    h = h * n

    plotter.move(h + 1, 1)
    urd(order)
    plotter.drawRel(h, h)
    lur(order)
    plotter.drawRel(-h, h)
    dlu(order)
    plotter.drawRel(-h, -h)
    rdl(order)
    plotter.drawRel(h, -h)
