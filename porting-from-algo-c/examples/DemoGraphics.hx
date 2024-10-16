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
	final style = new StyleMaker()
		.add(Fill(None))
		.add(Stroke(Black));

	demoA("results/ccurve-hx", style);
	demoB("results/ccurve-hx-WB-A", style);
	demoC("results/ccurve-hx-WB-B", style);
}

private function demoA(prefix, n=10, style) {
	'${prefix}.svg'.withSvgPlot(400, 250, (plotter) -> {
		plotter
			.pathStart()
			.move(100, 200)
			.cCurve(n, 200, 0)
			.pathEnd(false, style);
	});

	'${prefix}-E.svg'.withSvgPlotE(400, 250, (plotter) -> {
		plotter
			.plot(PathStart)
			.plot(Move(100, 200))
			.cCurveE(n, 200, 0)
			.plot(PathEnd(false, style));
	});
}

private function demoB(prefix, n=10, style) {
	final plotter = new SvgPlotWholeBuffer(400, 250);
	final plotterE = new SvgPlotWholeBufferE(400, 250);

	plotter
		.pathStart()
		.move(100, 200)
		.cCurve(n, 200, 0)
		.pathEnd(false, style);

	plotterE
		.plot(PathStart)
		.plot(Move(100, 200))
		.cCurveE(n, 200, 0)
		.plot(PathEnd(false, style));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n=10, style) {
	'${prefix}.svg'.withSvgPlotWithBuffer(400, 250, 30, (plotter) -> {
		plotter
			.pathStart()
			.move(100, 200)
			.cCurve(n, 200, 0)
			.pathEnd(false, style);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(400, 250, 30, (plotter) -> {
		plotter
			.plot(PathStart)
			.plot(Move(100, 200))
			.cCurveE(n, 200, 0)
			.plot(PathEnd(false, style));
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
	'${prefix}.svg'.withSvgPlot(x, y, (plotter) -> {
		plotter.randomCircle(n, x, y, styleR, styleC);
	});

	'${prefix}-E.svg'.withSvgPlotE(x, y, (plotter) -> {
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
	'${prefix}.svg'.withSvgPlotWithBuffer(x, y, 30, (plotter) -> {
		plotter.randomCircle(n, x, y, styleR, styleC);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(x, y, 30, (plotter) -> {
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
	'${prefix}.svg'.withSvgPlot(x, y, (plotter) -> {
		plotter.randomEllipse(n, x, y, styleR, styleE);
	});

	'${prefix}-E.svg'.withSvgPlotE(x, y, (plotter) -> {
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
	'${prefix}.svg'.withSvgPlotWithBuffer(x, y, 30, (plotter) -> {
		plotter.randomEllipse(n, x, y, styleR, styleE);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(x, y, 30, (plotter) -> {
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
	'${prefix}.svg'.withSvgPlot(x, y, (plotter) -> {
		plotter.randomLine(n, x, y, styleR, styleL);
	});

	'${prefix}-E.svg'.withSvgPlotE(x, y, (plotter) -> {
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
	'${prefix}.svg'.withSvgPlotWithBuffer(x, y, 30, (plotter) -> {
		plotter.randomLine(n, x, y, styleR, styleL);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(x, y, 30, (plotter) -> {
		plotter.randomLineE(n, x, y, styleR, styleL);
	});
}
#end

#if lissajouscurve
using src.LissajousCurve;

private function demo() {
	final n = 300;
	final offset = 10;
	final style = new StyleMaker()
		.add(Fill(None))
		.add(Stroke(Black));

	demoA("results/lissajouscurve-hx", n, offset, style);
	demoB("results/lissajouscurve-hx-WB-A", n, offset, style);
	demoC("results/lissajouscurve-hx-WB-B", n, offset, style);
}

private function demoA(prefix, n, offset, style) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.withSvgPlot(size, size, (plotter) -> {
		plotter
			.pathStart()
			.lissajousCurve(n, offset)
			.pathEnd(true, style);
	});

	'${prefix}-E.svg'.withSvgPlotE(size, size, (plotter) -> {
		plotter
			.plot(PathStart)
			.lissajousCurveE(n, offset)
			.plot(PathEnd(true, style));
	});
}

private function demoB(prefix, n, offset, style) {
	final size = (n + offset) * 2;

	final plotter = new SvgPlotWholeBuffer(size, size);
	final plotterE = new SvgPlotWholeBufferE(size, size);

	plotter
		.pathStart()
		.lissajousCurve(n, offset)
		.pathEnd(true, style);

	plotterE
		.plot(PathStart)
		.lissajousCurveE(n, offset)
		.plot(PathEnd(true, style));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, offset, style) {
	final size = (n + offset) * 2;

	'${prefix}.svg'.withSvgPlotWithBuffer(size, size, 30, (plotter) -> {
		plotter
			.pathStart()
			.lissajousCurve(n, offset)
			.pathEnd(true, style);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(size, size, 30, (plotter) -> {
		plotter
			.plot(PathStart)
			.lissajousCurveE(n, offset)
			.plot(PathEnd(true, style));
	});
}
#end

#if svgplot
private function demo() {
	final size = 300;
	final offset = 10;

	final styleA = new StyleMaker()
		.add(Fill(None))
		.add(Stroke(Black));
	final styleB = new StyleMaker()
		.add(Fill(None))
		.add(Stroke(RandomRGB))
		.add(StrokeWidth(5));
	final styleC = new StyleMaker()
		.add(Fill(RandomRGB))
		.add(Stroke(RandomRGB))
		.add(StrokeWidth(10));

	demoA("results/svgplot-hx", size, offset, styleA);
	demoB("results/svgplot-hx-WB-A", size, offset, styleB);
	demoC("results/svgplot-hx-WB-B", size, offset, styleC);
}

private function demoA(prefix, n, offset, style) {
	'${prefix}.svg'.withSvgPlot(n, n, (plotter) -> {
		plotter
			.pathStart()
			.sample(n, offset)
			.pathEnd(true, style);
	});

	'${prefix}-E.svg'.withSvgPlotE(n, n, (plotter) -> {
		plotter
			.plot(PathStart)
			.sampleE(n, offset)
			.plot(PathEnd(true, style));
	});
}

private function demoB(prefix, n, offset, style) {
	final plotter = new SvgPlotWholeBuffer(n, n);
	final plotterE = new SvgPlotWholeBufferE(n, n);

	plotter
		.pathStart()
		.sample(n, offset)
		.pathEnd(true, style);

	plotterE
		.plot(PathStart)
		.sampleE(n, offset)
		.plot(PathEnd(true, style));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n, offset, style) {
	'${prefix}.svg'.withSvgPlotWithBuffer(n, n, 2, (plotter) -> {
		plotter
			.pathStart()
			.sample(n, offset)
			.pathEnd(true, style);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(n, n, 2, (plotter) -> {
		plotter
			.plot(PathStart)
			.sampleE(n, offset)
			.plot(PathEnd(true, style));
	});
}
#end

#if treecurve
using src.TreeCurve;

private function demo() {
	final style = new StyleMaker()
		.add(Fill(None))
		.add(Stroke(Black));

	demoA("results/treecurve-hx", style);
	demoB("results/treecurve-hx-WB-A", style);
	demoC("results/treecurve-hx-WB-B", style);
}

private function demoA(prefix, n=10, style) {
	'${prefix}.svg'.withSvgPlot(400, 350, (plotter) -> {
		plotter
			.pathStart()
			.move(200, 0)
			.treeCurve(n, 100, 0, 0.7, 0.5)
			.pathEnd(false, style);
	});

	'${prefix}-E.svg'.withSvgPlotE(400, 350, (plotter) -> {
		plotter
			.plot(PathStart)
			.plot(Move(200, 0))
			.treeCurveE(n, 100, 0, 0.7, 0.5)
			.plot(PathEnd(false, style));
	});
}

private function demoB(prefix, n=10, style) {
	final plotter = new SvgPlotWholeBuffer(400, 350);
	final plotterE = new SvgPlotWholeBufferE(400, 350);

	plotter
		.pathStart()
		.move(200, 0)
		.treeCurve(n, 100, 0, 0.7, 0.5)
		.pathEnd(false, style);

	plotterE
		.plot(PathStart)
		.plot(Move(200, 0))
		.treeCurveE(n, 100, 0, 0.7, 0.5)
		.plot(PathEnd(false, style));

	'${prefix}.svg'.fileWrite((fh) -> { plotter.write(fh); });
	'${prefix}-E.svg'.fileWrite((fh) -> { plotterE.write(fh); });
}

private function demoC(prefix, n=10, style) {
	'${prefix}.svg'.withSvgPlotWithBuffer(400, 350, 100, (plotter) -> {
		plotter
			.pathStart()
			.move(200, 0)
			.treeCurve(n, 100, 0, 0.7, 0.5)
			.pathEnd(false, style);
	});

	'${prefix}-E.svg'.withSvgPlotWithBufferE(400, 350, 100, (plotter) -> {
		plotter
			.plot(PathStart)
			.plot(Move(200, 0))
			.treeCurveE(n, 100, 0, 0.7, 0.5)
			.plot(PathEnd(false, style));
	});
}
#end

function main()
	demo();
