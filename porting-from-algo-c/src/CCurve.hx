//
//	from src/ccurve.c
//
//	void c(int, double, double)	to	cCurve / cCurveE
//

package src;

using src.SvgPlot;

function cCurve(plotter:Plotter, i:Int, x:Float, y:Float):Plotter {
	rec(plotter, i, x, y);
	return plotter;
}

function cCurveE(plotter:PlotterE, i:Int, x:Float, y:Float):PlotterE {
	recE(plotter, i, x, y);
	return plotter;
}

private function rec(plotter:Plotter, i:Int, x:Float, y:Float)
	if (i == 0) {
		plotter.drawRel(x, y);
	} else {
		rec(plotter, i - 1, (x + y) / 2, (y - x) / 2);
		rec(plotter, i - 1, (x - y) / 2, (y + x) / 2);
	}

private function recE(plotter:PlotterE, i:Int, x:Float, y:Float)
	if (i == 0) {
		plotter.plot(DrawRel(x, y));
	} else {
		recE(plotter, i - 1, (x + y) / 2, (y - x) / 2);
		recE(plotter, i - 1, (x - y) / 2, (y + x) / 2);
	}
