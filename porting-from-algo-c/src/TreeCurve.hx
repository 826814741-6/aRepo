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

//

private function demoA(prefix, n=10) {
	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlot(400, 350);

		plotter.plotStart(fh);
		plotter.move(200, 0);
		treeCurve(plotter, n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotE(400, 350);

		plotter.plotStart(fh);
		plotter.plot(Move(200, 0));
		treeCurveE(plotter, n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});
}

private function demoB(prefix, n=10) {
	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWholeBuffering(400, 350);

		plotter.move(200, 0);
		treeCurve(plotter, n, 100, 0, 0.7, 0.5);

		plotter.write(fh);
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWholeBufferingE(400, 350);

		plotter.plot(Move(200, 0));
		treeCurveE(plotter, n, 100, 0, 0.7, 0.5);

		plotter.write(fh);
	});
}

private function demoC(prefix, n=10) {
	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBuffering(400, 350);

		plotter.plotStart(fh, 30);
		plotter.move(200, 0);
		treeCurve(plotter, n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBufferingE(400, 350);

		plotter.plotStart(fh, 30);
		plotter.plot(Move(200, 0));
		treeCurveE(plotter, n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});
}

//

function demo() {
	demoA("results/treecurve-hx");
	demoB("results/treecurve-hx-WB-A");
	demoC("results/treecurve-hx-WB-B");
}
