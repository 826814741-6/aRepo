//
//	some demo of basic shapes:
//
//	.circle / Circle, .ellipse / Ellipse, .line / Line
//

package src;

import src.Helper.rndUInt24;

using src.SvgPlot;

function randomCircle(plotter:Plotter, n, x, y, styleR, styleC) {
	plotter.rect(0, 0, x, y, 0, 0, styleR);
	for (_ in 0...n)
		plotter.circle(
			rndUInt24() % x,
			rndUInt24() % y,
			rndUInt24() % 100,
			styleC
		);
}

function randomCircleE(plotter:PlotterE, n, x, y, styleR, styleC) {
	plotter.plot(Rect(0, 0, x, y, 0, 0, styleR));
	for (_ in 0...n)
		plotter.plot(Circle(
			rndUInt24() % x,
			rndUInt24() % y,
			rndUInt24() % 100,
			styleC
		));
}

function randomEllipse(plotter:Plotter, n, x, y, styleR, styleE) {
	plotter.rect(0, 0, x, y, 0, 0, styleR);
	for (_ in 0...n)
		plotter.ellipse(
			rndUInt24() % x,
			rndUInt24() % y,
			rndUInt24() % 100,
			rndUInt24() % 100,
			styleE
		);
}

function randomEllipseE(plotter:PlotterE, n, x, y, styleR, styleE) {
	plotter.plot(Rect(0, 0, x, y, 0, 0, styleR));
	for (_ in 0...n)
		plotter.plot(Ellipse(
			rndUInt24() % x,
			rndUInt24() % y,
			rndUInt24() % 100,
			rndUInt24() % 100,
			styleE
		));
}

function randomLine(plotter:Plotter, n, x, y, styleR, styleL) {
	plotter.rect(0, 0, x, y, 0, 0, styleR);
	for (_ in 0...n)
		plotter.line(
			rndUInt24() % x,
			rndUInt24() % y,
			rndUInt24() % x,
			rndUInt24() % y,
			styleL
		);
}

function randomLineE(plotter:PlotterE, n, x, y, styleR, styleL) {
	plotter.plot(Rect(0, 0, x, y, 0, 0, styleR));
	for (_ in 0...n)
		plotter.plot(Line(
			rndUInt24() % x,
			rndUInt24() % y,
			rndUInt24() % x,
			rndUInt24() % y,
			styleL
		));
}
