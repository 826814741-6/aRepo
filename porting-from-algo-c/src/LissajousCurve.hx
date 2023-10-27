//
//	from src/lissaj.c
//
//	a part of main		to	lissajousCurve / lissajousCurveE
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

function lissajousCurveE(plotter:SvgPlot.PlotterE, n:Int, offset:Int) {
	plotter.plot(Move(stepX(n, offset, 0), stepY(n, offset, 0)));
	for (i in 1...361)
		plotter.plot(Draw(
			stepX(n, offset, 3 * (Math.PI / 180) * i),
			stepY(n, offset, 5 * (Math.PI / 180) * i)
		));
}

//

private function demoA(prefix, n, offset) {
	final size = (n + offset) * 2;

	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		final plotter = new SvgPlot.SvgPlot(size, size);

		plotter.plotStart(fh);
		lissajousCurve(plotter, n, offset);
		plotter.plotEnd(true);
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		final plotter = new SvgPlot.SvgPlotE(size, size);

		plotter.plotStart(fh);
		lissajousCurveE(plotter, n, offset);
		plotter.plotEnd(true);
	});
}

private function demoB(prefix, n, offset) {
	final size = (n + offset) * 2;

	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		final plotter = new SvgPlot.SvgPlotWholeBuffering(size, size);

		lissajousCurve(plotter, n, offset);
		plotter.plotEnd(true);

		plotter.write(fh);
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		final plotter = new SvgPlot.SvgPlotWholeBufferingE(size, size);

		lissajousCurveE(plotter, n, offset);
		plotter.plotEnd(true);

		plotter.write(fh);
	});
}

private function demoC(prefix, n, offset) {
	final size = (n + offset) * 2;

	Helper.withFileWrite('${prefix}.svg', (fh) -> {
		final plotter = new SvgPlot.SvgPlotWithBuffering(size, size);

		plotter.plotStart(fh, 30);
		lissajousCurve(plotter, n, offset);
		plotter.plotEnd(true);
	});

	Helper.withFileWrite('${prefix}-E.svg', (fh) -> {
		final plotter = new SvgPlot.SvgPlotWithBufferingE(size, size);

		plotter.plotStart(fh, 30);
		lissajousCurveE(plotter, n, offset);
		plotter.plotEnd(true);
	});
}

//

function demo() {
	final n = 300;
	final offset = 10;

	demoA("results/lissajouscurve-hx", n, offset);
	demoB("results/lissajouscurve-hx-WB-A", n, offset);
	demoC("results/lissajouscurve-hx-WB-B", n, offset);
}
