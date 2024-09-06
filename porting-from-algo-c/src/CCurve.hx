//
//	from src/ccurve.c
//
//	void c(int, double, double)	to	cCurve / cCurveE
//

package src;

function cCurve(plotter:SvgPlot.Plotter, i:Int, x:Float, y:Float)
	if (i == 0) {
		plotter.drawRel(x, y);
	} else {
		cCurve(plotter, i - 1, (x + y) / 2, (y - x) / 2);
		cCurve(plotter, i - 1, (x - y) / 2, (y + x) / 2);
	}

function cCurveE(plotter:SvgPlot.PlotterE, i:Int, x:Float, y:Float)
	if (i == 0) {
		plotter.plot(DrawRel(x, y));
	} else {
		cCurveE(plotter, i - 1, (x + y) / 2, (y - x) / 2);
		cCurveE(plotter, i - 1, (x - y) / 2, (y + x) / 2);
	}
