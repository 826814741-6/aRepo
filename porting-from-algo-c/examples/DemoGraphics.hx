//
//	from src/ccurve.c		to	ccurve
//	from src/lissajouscurve.c	to	lissajouscurve
//	from src/svgplot.c		to	svgplot
//	from src/treecurve.c		to	treecurve
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
		plotter.move(100, 200);
		plotter.cCurve(n, 200, 0);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(400, 250);

		plotter.plotStart(fh);
		plotter.plot(Move(100, 200));
		plotter.cCurveE(n, 200, 0);
		plotter.plotEnd();
	});
}

private function demoB(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBuffering(400, 250);

		plotter.move(100, 200);
		plotter.cCurve(n, 200, 0);

		plotter.write(fh);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBufferingE(400, 250);

		plotter.plot(Move(100, 200));
		plotter.cCurveE(n, 200, 0);

		plotter.write(fh);
	});
}

private function demoC(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(400, 250);

		plotter.plotStart(fh, 30);
		plotter.move(100, 200);
		plotter.cCurve(n, 200, 0);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(400, 250);

		plotter.plotStart(fh, 30);
		plotter.plot(Move(100, 200));
		plotter.cCurveE(n, 200, 0);
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
		plotter.lissajousCurve(n, offset);
		plotter.plotEnd(true);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(size, size);

		plotter.plotStart(fh);
		plotter.lissajousCurveE(n, offset);
		plotter.plotEnd(true);
	});
}

private function demoB(prefix, n, offset) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBuffering(size, size);

		plotter.lissajousCurve(n, offset);
		plotter.plotEnd(true);

		plotter.write(fh);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBufferingE(size, size);

		plotter.lissajousCurveE(n, offset);
		plotter.plotEnd(true);

		plotter.write(fh);
	});
}

private function demoC(prefix, n, offset) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(size, size);

		plotter.plotStart(fh, 30);
		plotter.lissajousCurve(n, offset);
		plotter.plotEnd(true);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(size, size);

		plotter.plotStart(fh, 30);
		plotter.lissajousCurveE(n, offset);
		plotter.plotEnd(true);
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
		plotter.sample();
		plotter.plotEnd(true);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(300, 300);

		plotter.plotStart(fh);
		plotter.sampleE();
		plotter.plotEnd(true);
	});
}

private function demoB(prefix) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBuffering(300, 300);

		plotter.sample();
		plotter.plotEnd(true);

		plotter.write(fh);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBufferingE(300, 300);

		plotter.sampleE();
		plotter.plotEnd(true);

		plotter.write(fh);
	});
}

private function demoC(prefix) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(300, 300);

		plotter.plotStart(fh, 2);
		plotter.sample();
		plotter.plotEnd(true);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(300, 300);

		plotter.plotStart(fh, 2);
		plotter.sampleE();
		plotter.plotEnd(true);
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
		plotter.move(200, 0);
		plotter.treeCurve(n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotE(400, 350);

		plotter.plotStart(fh);
		plotter.plot(Move(200, 0));
		plotter.treeCurveE(n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});
}

private function demoB(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBuffering(400, 350);

		plotter.move(200, 0);
		plotter.treeCurve(n, 100, 0, 0.7, 0.5);

		plotter.write(fh);
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWholeBufferingE(400, 350);

		plotter.plot(Move(200, 0));
		plotter.treeCurveE(n, 100, 0, 0.7, 0.5);

		plotter.write(fh);
	});
}

private function demoC(prefix, n=10) {
	'${prefix}.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBuffering(400, 350);

		plotter.plotStart(fh, 30);
		plotter.move(200, 0);
		plotter.treeCurve(n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});

	'${prefix}-E.svg'.fileWrite((fh) -> {
		final plotter = new SvgPlotWithBufferingE(400, 350);

		plotter.plotStart(fh, 30);
		plotter.plot(Move(200, 0));
		plotter.treeCurveE(n, 100, 0, 0.7, 0.5);
		plotter.plotEnd();
	});
}
#end

function main() {
	demo();
}
