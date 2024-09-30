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
	'${prefix}.svg'.withPlt(new SvgPlot(400, 250))
		((plotter) -> {
			plotter
				.pathStart()
				.move(100, 200)
				.cCurve(n, 200, 0)
				.pathEnd(false);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(400, 250))
		((plotter) -> {
			plotter
				.plot(PathStart)
				.plot(Move(100, 200))
				.cCurveE(n, 200, 0)
				.plot(PathEnd(false));
		});
}

private function demoB(prefix, n=10) {
	final plotter = new SvgPlotWholeBuffer(400, 250);
	final plotterE = new SvgPlotWholeBufferE(400, 250);

	plotter
		.pathStart()
		.move(100, 200)
		.cCurve(n, 200, 0)
		.pathEnd(false);

	plotterE
		.plot(PathStart)
		.plot(Move(100, 200))
		.cCurveE(n, 200, 0)
		.plot(PathEnd(false));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n=10) {
	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(400, 250), 30)
		((plotter) -> {
			plotter
				.pathStart()
				.move(100, 200)
				.cCurve(n, 200, 0)
				.pathEnd(false);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(400, 250), 30)
		((plotter) -> {
			plotter
				.plot(PathStart)
				.plot(Move(100, 200))
				.cCurveE(n, 200, 0)
				.plot(PathEnd(false));
		});
}
#end

#if circle
using src.BasicShapes;

private function demo() {
	final n = 100;
	final x = 640;
	final y = 400;

	final styleR = new StyleMaker()
		.add(Fill(Black));
	final styleC = new StyleMaker()
		.add(Fill(Transparent))
		.add(Stroke(RandomRGB))
		.add(StrokeWidth(1));

	demoA("results/circle-hx", n, x, y, styleR, styleC);
	demoB("results/circle-hx-WB-A", n, x, y, styleR, styleC);
	demoC("results/circle-hx-WB-B", n, x, y, styleR, styleC);
}

private function demoA(prefix, n, x, y, styleR, styleC) {
	'${prefix}.svg'.withPlt(new SvgPlot(x, y))
		((plotter) -> {
			plotter.randomCircle(n, x, y, styleR, styleC);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(x, y))
		((plotter) -> {
			plotter.randomCircleE(n, x, y, styleR, styleC);
		});
}

private function demoB(prefix, n, x, y, styleR, styleC) {
	final plotter = new SvgPlotWholeBuffer(x, y);
	final plotterE = new SvgPlotWholeBufferE(x, y);

	plotter.randomCircle(n, x, y, styleR, styleC);
	plotterE.randomCircleE(n, x, y, styleR, styleC);

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, x, y, styleR, styleC) {
	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(x, y), 30)
		((plotter) -> {
			plotter.randomCircle(n, x, y, styleR, styleC);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(x, y), 30)
		((plotter) -> {
			plotter.randomCircleE(n, x, y, styleR, styleC);
		});
}
#end

#if ellipse
using src.BasicShapes;

private function demo() {
	final n = 100;
	final x = 640;
	final y = 400;

	final styleR = new StyleMaker()
		.add(Fill(Black));
	final styleE = new StyleMaker()
		.add(Fill(Transparent))
		.add(Stroke(RandomRGB))
		.add(StrokeWidth(1));

	demoA("results/ellipse-hx", n, x, y, styleR, styleE);
	demoB("results/ellipse-hx-WB-A", n, x, y, styleR, styleE);
	demoC("results/ellipse-hx-WB-B", n, x, y, styleR, styleE);
}

private function demoA(prefix, n, x, y, styleR, styleE) {
	'${prefix}.svg'.withPlt(new SvgPlot(x, y))
		((plotter) -> {
			plotter.randomEllipse(n, x, y, styleR, styleE);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(x, y))
		((plotter) -> {
			plotter.randomEllipseE(n, x, y, styleR, styleE);
		});
}

private function demoB(prefix, n, x, y, styleR, styleE) {
	final plotter = new SvgPlotWholeBuffer(x, y);
	final plotterE = new SvgPlotWholeBufferE(x, y);

	plotter.randomEllipse(n, x, y, styleR, styleE);
	plotterE.randomEllipseE(n, x, y, styleR, styleE);

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, x, y, styleR, styleE) {
	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(x, y), 30)
		((plotter) -> {
			plotter.randomEllipse(n, x, y, styleR, styleE);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(x, y), 30)
		((plotter) -> {
			plotter.randomEllipseE(n, x, y, styleR, styleE);
		});
}
#end

#if line
using src.BasicShapes;

private function demo() {
	final n = 100;
	final x = 640;
	final y = 400;

	final styleR = new StyleMaker()
		.add(Fill(Black));
	final styleL = new StyleMaker()
		.add(Fill(Transparent))
		.add(Stroke(RandomRGB))
		.add(StrokeWidth(1));

	demoA("results/line-hx", n, x, y, styleR, styleL);
	demoB("results/line-hx-WB-A", n, x, y, styleR, styleL);
	demoC("results/line-hx-WB-B", n, x, y, styleR, styleL);
}

private function demoA(prefix, n, x, y, styleR, styleL) {
	'${prefix}.svg'.withPlt(new SvgPlot(x, y))
		((plotter) -> {
			plotter.randomLine(n, x, y, styleR, styleL);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(x, y))
		((plotter) -> {
			plotter.randomLineE(n, x, y, styleR, styleL);
		});
}

private function demoB(prefix, n, x, y, styleR, styleL) {
	final plotter = new SvgPlotWholeBuffer(x, y);
	final plotterE = new SvgPlotWholeBufferE(x, y);

	plotter.randomLine(n, x, y, styleR, styleL);
	plotterE.randomLineE(n, x, y, styleR, styleL);

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, x, y, styleR, styleL) {
	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(x, y), 30)
		((plotter) -> {
			plotter.randomLine(n, x, y, styleR, styleL);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(x, y), 30)
		((plotter) -> {
			plotter.randomLineE(n, x, y, styleR, styleL);
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

	'${prefix}.svg'.withPlt(new SvgPlot(size, size))
		((plotter) -> {
			plotter
				.pathStart()
				.lissajousCurve(n, offset)
				.pathEnd(true);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(size, size))
		((plotter) -> {
			plotter
				.plot(PathStart)
				.lissajousCurveE(n, offset)
				.plot(PathEnd(true));
		});
}

private function demoB(prefix, n, offset) {
	final size = (n + offset) * 2;

	final plotter = new SvgPlotWholeBuffer(size, size);
	final plotterE = new SvgPlotWholeBufferE(size, size);

	plotter
		.pathStart()
		.lissajousCurve(n, offset)
		.pathEnd(true);

	plotterE
		.plot(PathStart)
		.lissajousCurveE(n, offset)
		.plot(PathEnd(true));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, offset) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(size, size), 30)
		((plotter) -> {
			plotter
				.pathStart()
				.lissajousCurve(n, offset)
				.pathEnd(true);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(size, size), 30)
		((plotter) -> {
			plotter
				.plot(PathStart)
				.lissajousCurveE(n, offset)
				.plot(PathEnd(true));
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
	'${prefix}.svg'.withPlt(new SvgPlot(300, 300))
		((plotter) -> {
			plotter
				.pathStart()
				.sample()
				.pathEnd(true);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(300, 300))
		((plotter) -> {
			plotter
				.plot(PathStart)
				.sampleE()
				.plot(PathEnd(true));
		});
}

private function demoB(prefix) {
	final plotter = new SvgPlotWholeBuffer(300, 300);
	final plotterE = new SvgPlotWholeBufferE(300, 300);

	plotter
		.pathStart()
		.sample()
		.pathEnd(true);

	plotterE
		.plot(PathStart)
		.sampleE()
		.plot(PathEnd(true));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix) {
	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(300, 300), 2)
		((plotter) -> {
			plotter
				.pathStart()
				.sample()
				.pathEnd(true);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(300, 300), 2)
		((plotter) -> {
			plotter
				.plot(PathStart)
				.sampleE()
				.plot(PathEnd(true));
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
	'${prefix}.svg'.withPlt(new SvgPlot(400, 350))
		((plotter) -> {
			plotter
				.pathStart()
				.move(200, 0)
				.treeCurve(n, 100, 0, 0.7, 0.5)
				.pathEnd(false);
		});

	'${prefix}-E.svg'.withPltE(new SvgPlotE(400, 350))
		((plotter) -> {
			plotter
				.plot(PathStart)
				.plot(Move(200, 0))
				.treeCurveE(n, 100, 0, 0.7, 0.5)
				.plot(PathEnd(false));
		});
}

private function demoB(prefix, n=10) {
	final plotter = new SvgPlotWholeBuffer(400, 350);
	final plotterE = new SvgPlotWholeBufferE(400, 350);

	plotter
		.pathStart()
		.move(200, 0)
		.treeCurve(n, 100, 0, 0.7, 0.5)
		.pathEnd(false);

	plotterE
		.plot(PathStart)
		.plot(Move(200, 0))
		.treeCurveE(n, 100, 0, 0.7, 0.5)
		.plot(PathEnd(false));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n=10) {
	'${prefix}.svg'.withPltWB(new SvgPlotWithBuffer(400, 350), 100)
		((plotter) -> {
			plotter
				.pathStart()
				.move(200, 0)
				.treeCurve(n, 100, 0, 0.7, 0.5)
				.pathEnd(false);
		});

	'${prefix}-E.svg'.withPltWBE(new SvgPlotWithBufferE(400, 350), 100)
		((plotter) -> {
			plotter
				.plot(PathStart)
				.plot(Move(200, 0))
				.treeCurveE(n, 100, 0, 0.7, 0.5)
				.plot(PathEnd(false));
		});
}
#end

function main()
	demo();
