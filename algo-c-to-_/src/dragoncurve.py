#
#	from src/dragon.c
#
#	void dragon(int, double, double, int)	to	dragonCurveR
#
#	from src/dragon2.c
#
#	a part of main				to	dragonCurve
#

def _iter(plotter, i, dx, dy, sign):
    if i == 0:
        plotter.drawRel(dx, dy)
    else:
        _iter(plotter, i-1, (dx - sign*dy) / 2, (dy + sign*dx) / 2, 1)
        _iter(plotter, i-1, (dx + sign*dy) / 2, (dy - sign*dx) / 2, -1)

def dragonCurveR(plotter, order, dx, dy, sign, x0, y0):
    plotter.move(x0, y0)
    _iter(plotter, order, dx, dy, sign)

def dragonCurve(plotter, order, x0, y0):
    plotter.move(x0, y0)

    dx, dy = 0, 2
    plotter.drawRel(3 * dx, 3 * dy)

    fold, p = [ False for _ in range(1 << order) ], 0
    for _ in range(order):
        fold[p], q = True, 2 * p
        for i in range(p, q+1):
            if fold[q-i] == True:
                fold[i], dx1, dy1 = False, dy, -dx
            else:
                fold[i], dx1, dy1 = True, -dy, dx

            plotter.drawRel(dx + dx1, dy + dy1)
            plotter.drawRel(3 * dx1, 3 * dy1)

            dx, dy = dx1, dy1
        p = q + 1
