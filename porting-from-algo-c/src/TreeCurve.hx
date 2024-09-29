//
//	from src/treecurv.c
//
//	void tree(int, double, double)		to	treeCurve / treeCurveE
//

package src;

using src.SvgPlot;

function treeCurve(
	plotter:Plotter,
	n:Int,
	length:Float,
	angle:Float,
	factor:Float,
	turn:Float
) {
	rec(plotter, n, length, angle, factor, turn);
	return plotter;
}

function treeCurveE(
	plotter:PlotterE,
	n:Int,
	length:Float,
	angle:Float,
	factor:Float,
	turn:Float
) {
	recE(plotter, n, length, angle, factor, turn);
	return plotter;
}

private function rec(
	plotter:Plotter,
	n:Int,
	length:Float,
	angle:Float,
	factor:Float,
	turn:Float
) {
	final x = length * Math.sin(angle);
	final y = length * Math.cos(angle);

	plotter.drawRel(x, y);

	if (n > 0) {
		rec(plotter, n - 1, length * factor, angle + turn, factor, turn);
		rec(plotter, n - 1, length * factor, angle - turn, factor, turn);
	}

	plotter.moveRel(-x, -y);
}

private function recE(
	plotter:PlotterE,
	n:Int,
	length:Float,
	angle:Float,
	factor:Float,
	turn:Float
) {
	final x = length * Math.sin(angle);
	final y = length * Math.cos(angle);

	plotter.plot(DrawRel(x, y));

	if (n > 0) {
		recE(plotter, n - 1, length * factor, angle + turn, factor, turn);
		recE(plotter, n - 1, length * factor, angle - turn, factor, turn);
	}

	plotter.plot(MoveRel(-x, -y));
}
