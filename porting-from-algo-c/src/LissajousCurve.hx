//
//	from src/lissaj.c
//
//	a part of main		to	lissajousCurve
//

package src;

private inline function stepX(n:Int, offset:Int, x:Float):Float {
	return n + offset + n * Math.cos(x);
}

private inline function stepY(n:Int, offset:Int, y:Float):Float {
	return n + offset + n * Math.sin(y);
}

function lissajousCurve(plotter:SvgPlot.Plotter, n:Int, offset:Int) {
	plotter.move(stepX(n, offset, 0), stepY(n, offset, 0));
	for (i in 1...361)
		plotter.draw(
			stepX(n, offset, 3 * (Math.PI / 180) * i),
			stepY(n, offset, 5 * (Math.PI / 180) * i)
		);
}

//

private function demoA(path, n, offset) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlot((n + offset) * 2, (n + offset) * 2);

		plotter.plotStart(fh);
		lissajousCurve(plotter, n, offset);
		plotter.plotEnd(true);
	});
}

private function demoB(path, n, offset) {
	var plotter = new SvgPlot.SvgPlotWholeBuffering((n + offset) * 2, (n + offset) * 2);

	lissajousCurve(plotter, n, offset);
	plotter.plotEnd(true);

	Helper.withFileWrite(path, (fh) -> plotter.write(fh));
}

private function demoC(path, n, offset) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlotWithBuffering((n + offset) * 2, (n + offset) * 2);

		plotter.plotStart(fh, 30);
		lissajousCurve(plotter, n, offset);
		plotter.plotEnd(true);
	});
}

function demo() {
	final n = 300;
	final offset = 10;

	demoA("results/lissajouscurve-hx.svg", n, offset);
	demoB("results/lissajouscurve-hx-WB-A.svg", n, offset);
	demoC("results/lissajouscurve-hx-WB-B.svg", n, offset);
}
