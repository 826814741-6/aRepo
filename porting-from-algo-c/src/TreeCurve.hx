//
//	from src/treecurv.c
//
//	void tree(int, double, double)		to	treeCurve / treeCurveE
//

package src;

function treeCurve(
	plotter:SvgPlot.Plotter,
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
		treeCurve(plotter, n - 1, length * factor, angle + turn, factor, turn);
		treeCurve(plotter, n - 1, length * factor, angle - turn, factor, turn);
	}

	plotter.moveRel(-x, -y);
}

function treeCurveE(
	plotter:SvgPlot.PlotterE,
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
		treeCurveE(plotter, n - 1, length * factor, angle + turn, factor, turn);
		treeCurveE(plotter, n - 1, length * factor, angle - turn, factor, turn);
	}

	plotter.plot(MoveRel(-x, -y));
}
