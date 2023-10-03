//
//	from src/ccurve.c
//
//	void c(int, double, double)	to	cCurve / cCurveE
//

package src;

function cCurve(plotter:SvgPlot.Plotter, i:Int, x:Float, y:Float) {
	if (i == 0) {
		plotter.drawRel(x, y);
	} else {
		cCurve(plotter, i - 1, (x + y) / 2, (y - x) / 2);
		cCurve(plotter, i - 1, (x - y) / 2, (y + x) / 2);
	}
}

function cCurveE(plotter:SvgPlot.PlotterE, i:Int, x:Float, y:Float) {
	if (i == 0) {
		plotter.plot(DrawRel(x, y));
	} else {
		cCurveE(plotter, i - 1, (x + y) / 2, (y - x) / 2);
		cCurveE(plotter, i - 1, (x - y) / 2, (y + x) / 2);
	}
}

//

private function demoA(prefix, n=10) {
	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlot(400, 250);

		plotter.plotStart(fh);
		plotter.move(100, 200);
		cCurve(plotter, n, 200, 0);
		plotter.plotEnd();
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotE(400, 250);

		plotter.plotStart(fh);
		plotter.plot(Move(100, 200));
		cCurveE(plotter, n, 200, 0);
		plotter.plotEnd();
	});
}

private function demoB(prefix, n=10) {
	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWholeBuffering(400, 250);

		plotter.move(100, 200);
		cCurve(plotter, n, 200, 0);

		plotter.write(fh);
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWholeBufferingE(400, 250);

		plotter.plot(Move(100, 200));
		cCurveE(plotter, n, 200, 0);

		plotter.write(fh);
	});
}

private function demoC(prefix, n=10) {
	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBuffering(400, 250);

		plotter.plotStart(fh, 30);
		plotter.move(100, 200);
		cCurve(plotter, n, 200, 0);
		plotter.plotEnd();
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBufferingE(400, 250);

		plotter.plotStart(fh, 30);
		plotter.plot(Move(100, 200));
		cCurveE(plotter, n, 200, 0);
		plotter.plotEnd();
	});
}

//

function demo() {
	demoA("results/ccurve-hx");
	demoB("results/ccurve-hx-WB-A");
	demoC("results/ccurve-hx-WB-B");
}
