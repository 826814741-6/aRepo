//
//	from src/treecurv.c
//
//	void tree(int, double, double)		to	treeCurve
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

//

private function demoA(path, n=10) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlot(400, 350);

		plotter.plotStart(fh);
		plotter.move(200, 0);
		treeCurve(plotter, n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});
}

private function demoB(path, n=10) {
	var plotter = new SvgPlot.SvgPlotWholeBuffering(400, 350);

	plotter.move(200, 0);
	treeCurve(plotter, n, 100, 0, 0.7, 0.5);
	plotter.plotEnd();

	Helper.withFileWrite(path, (fh) -> plotter.write(fh));
}

private function demoC(path, n=10) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBuffering(400, 350);

		plotter.plotStart(fh, 30);
		plotter.move(200, 0);
		treeCurve(plotter, n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});
}

function demo() {
	demoA("results/treecurve-hx.svg");
	demoB("results/treecurve-hx-WB-A.svg");
	demoC("results/treecurve-hx-WB-B.svg");
}
