//
//	from src/ccurve.c		to	ccurve
//	from src/lissaj.c		to	lissajouscurve
//	from src/svgplot.c		to	svgplot
//	from src/treecurv.c		to	treecurve
//

using src.Helper.PathStringExtender;
using src.SvgPlot;

#if ccurve
using src.CCurve;

private function demo() {
	demoA("results/ccurve-hx");
	demoB("results/ccurve-hx-WB-A");
	demoC("results/ccurve-hx-WB-B");
}

private function demoA(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlot(400, 250);

		plotter.plotStart(fh);
		plotter.pathStart();
		plotter.move(100, 200);
		plotter.cCurve(n, 200, 0);
		plotter.pathEnd(false);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(400, 250);

		plotter.plotStart(fh);
		plotter.plot(PathStart);
		plotter.plot(Move(100, 200));
		plotter.cCurveE(n, 200, 0);
		plotter.plot(PathEnd(false));
		plotter.plotEnd();
	});
}

private function demoB(prefix, n=10) {
	final plotter = new SvgPlotWholeBuffering(400, 250);
	final plotterE = new SvgPlotWholeBufferingE(400, 250);

	plotter.pathStart();
	plotterE.plot(PathStart);

	plotter.move(100, 200);
	plotterE.plot(Move(100, 200));

	plotter.cCurve(n, 200, 0);
	plotterE.cCurveE(n, 200, 0);

	plotter.pathEnd(false);
	plotterE.plot(PathEnd(false));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(400, 250);

		plotter.plotStart(fh, 30);
		plotter.pathStart();
		plotter.move(100, 200);
		plotter.cCurve(n, 200, 0);
		plotter.pathEnd(false);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(400, 250);

		plotter.plotStart(fh, 30);
		plotter.plot(PathStart);
		plotter.plot(Move(100, 200));
		plotter.cCurveE(n, 200, 0);
		plotter.plot(PathEnd(false));
		plotter.plotEnd();
	});
}
#end

#if lissajouscurve
using src.LissajousCurve;

private function demo() {
	final n = 300;
	final offset = 10;

	demoA("results/lissajouscurve-hx", n, offset);
	demoB("results/lissajouscurve-hx-WB-A", n, offset);
	demoC("results/lissajouscurve-hx-WB-B", n, offset);
}

private function demoA(prefix, n, offset) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlot(size, size);

		plotter.plotStart(fh);
		plotter.pathStart();
		plotter.lissajousCurve(n, offset);
		plotter.pathEnd(true);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(size, size);

		plotter.plotStart(fh);
		plotter.plot(PathStart);
		plotter.lissajousCurveE(n, offset);
		plotter.plot(PathEnd(true));
		plotter.plotEnd();
	});
}

private function demoB(prefix, n, offset) {
	final size = (n + offset) * 2;

	final plotter = new SvgPlotWholeBuffering(size, size);
	final plotterE = new SvgPlotWholeBufferingE(size, size);

	plotter.pathStart();
	plotterE.plot(PathStart);

	plotter.lissajousCurve(n, offset);
	plotterE.lissajousCurveE(n, offset);

	plotter.pathEnd(true);
	plotterE.plot(PathEnd(true));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, offset) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(size, size);

		plotter.plotStart(fh, 30);
		plotter.pathStart();
		plotter.lissajousCurve(n, offset);
		plotter.pathEnd(true);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(size, size);

		plotter.plotStart(fh, 30);
		plotter.plot(PathStart);
		plotter.lissajousCurveE(n, offset);
		plotter.plot(PathEnd(true));
		plotter.plotEnd();
	});
}
#end

#if svgplot
private function demo() {
	demoA("results/svgplot-hx");
	demoB("results/svgplot-hx-WB-A");
	demoC("results/svgplot-hx-WB-B");
}

private function demoA(prefix) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlot(300, 300);

		plotter.plotStart(fh);
		plotter.pathStart();
		plotter.sample();
		plotter.pathEnd(true);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(300, 300);

		plotter.plotStart(fh);
		plotter.plot(PathStart);
		plotter.sampleE();
		plotter.plot(PathEnd(true));
		plotter.plotEnd();
	});
}

private function demoB(prefix) {
	final plotter = new SvgPlotWholeBuffering(300, 300);
	final plotterE = new SvgPlotWholeBufferingE(300, 300);

	plotter.pathStart();
	plotterE.plot(PathStart);

	plotter.sample();
	plotterE.sampleE();

	plotter.pathEnd(true);
	plotterE.plot(PathEnd(true));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(300, 300);

		plotter.plotStart(fh, 2);
		plotter.pathStart();
		plotter.sample();
		plotter.pathEnd(true);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(300, 300);

		plotter.plotStart(fh, 2);
		plotter.plot(PathStart);
		plotter.sampleE();
		plotter.plot(PathEnd(true));
		plotter.plotEnd();
	});
}
#end

#if treecurve
using src.TreeCurve;

private function demo() {
	demoA("results/treecurve-hx");
	demoB("results/treecurve-hx-WB-A");
	demoC("results/treecurve-hx-WB-B");
}

private function demoA(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlot(400, 350);

		plotter.plotStart(fh);
		plotter.pathStart();
		plotter.move(200, 0);
		plotter.treeCurve(n, 100, 0, 0.7, 0.5);
		plotter.pathEnd(false);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(400, 350);

		plotter.plotStart(fh);
		plotter.plot(PathStart);
		plotter.plot(Move(200, 0));
		plotter.treeCurveE(n, 100, 0, 0.7, 0.5);
		plotter.plot(PathEnd(false));
		plotter.plotEnd();
	});
}

private function demoB(prefix, n=10) {
	final plotter = new SvgPlotWholeBuffering(400, 350);
	final plotterE = new SvgPlotWholeBufferingE(400, 350);

	plotter.pathStart();
	plotterE.plot(PathStart);

	plotter.move(200, 0);
	plotterE.plot(Move(200, 0));

	plotter.treeCurve(n, 100, 0, 0.7, 0.5);
	plotterE.treeCurveE(n, 100, 0, 0.7, 0.5);

	plotter.pathEnd(false);
	plotterE.plot(PathEnd(false));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(400, 350);

		plotter.plotStart(fh, 30);
		plotter.pathStart();
		plotter.move(200, 0);
		plotter.treeCurve(n, 100, 0, 0.7, 0.5);
		plotter.pathEnd(false);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(400, 350);

		plotter.plotStart(fh, 30);
		plotter.plot(PathStart);
		plotter.plot(Move(200, 0));
		plotter.treeCurveE(n, 100, 0, 0.7, 0.5);
		plotter.plot(PathEnd(false));
		plotter.plotEnd();
	});
}
#end

function main()
	demo();
