//
//	from src/ccurve.c
//
//	void c(int, double, double)	to	cCurve
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

//

private function demoA(path, n=10) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlot(400, 250);

		plotter.plotStart(fh);
		plotter.move(100, 200);
		cCurve(plotter, n, 200, 0);
		plotter.plotEnd();
	});
}

private function demoB(path, n=10) {
	var plotter = new SvgPlot.SvgPlotWholeBuffering(400, 250);

	plotter.move(100, 200);
	cCurve(plotter, n, 200, 0);
	plotter.plotEnd();

	Helper.withFileWrite(path, (fh) -> plotter.write(fh));
}

private function demoC(path, n=10) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBuffering(400, 250);

		plotter.plotStart(fh, 30);
		plotter.move(100, 200);
		cCurve(plotter, n, 200, 0);
		plotter.plotEnd();
	});
}

function demo() {
	demoA("results/ccurve-hx.svg");
	demoB("results/ccurve-hx-WB-A.svg");
	demoC("results/ccurve-hx-WB-B.svg");
}
