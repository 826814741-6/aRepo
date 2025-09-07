#
#  from src/ccurve.c
#
#    void c(int, double, double)  to  cCurve
#

def cCurve(plotter, i, x, y):
    if i == 0:
        plotter.drawRel(x, y)
    else:
        cCurve(plotter, i - 1, (x + y) / 2, (y - x) / 2)
        cCurve(plotter, i - 1, (x - y) / 2, (y + x) / 2)

def _demo(path, n):
    import svgplot

    with open(path, "w") as fh:
        plotter = svgplot.svgPlot(400, 250)
        plotter.plotStart(fh)
        plotter.pathStart()
        plotter.move(100, 200)
        cCurve(plotter, n, 200, 0)
        plotter.pathEnd()
        plotter.plotEnd()

if __name__ == "__main__":
    _demo("results/ccurve-py.svg", 10)
