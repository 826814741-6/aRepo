//
//	some demo of basic shapes:
//
//	.circle / Circle, .ellipse / Ellipse, .line / Line
//

package src;

using src.SvgPlot;

function randomCircle(plotter:Plotter, n, x, y, styleR, styleC) {
	plotter.rect(0, 0, x, y, 0, 0, styleR);
	for (_ in 0...n)
		plotter.circle(
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			Math.floor(Math.random() * 0xffffff) % 100,
			styleC
		);
}

function randomCircleE(plotter:PlotterE, n, x, y, styleR, styleC) {
	plotter.plot(Rect(0, 0, x, y, 0, 0, styleR));
	for (_ in 0...n)
		plotter.plot(Circle(
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			Math.floor(Math.random() * 0xffffff) % 100,
			styleC
		));
}

function randomEllipse(plotter:Plotter, n, x, y, styleR, styleE) {
	plotter.rect(0, 0, x, y, 0, 0, styleR);
	for (_ in 0...n)
		plotter.ellipse(
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			Math.floor(Math.random() * 0xffffff) % 100,
			Math.floor(Math.random() * 0xffffff) % 100,
			styleE
		);
}

function randomEllipseE(plotter:PlotterE, n, x, y, styleR, styleE) {
	plotter.plot(Rect(0, 0, x, y, 0, 0, styleR));
	for (_ in 0...n)
		plotter.plot(Ellipse(
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			Math.floor(Math.random() * 0xffffff) % 100,
			Math.floor(Math.random() * 0xffffff) % 100,
			styleE
		));
}

function randomLine(plotter:Plotter, n, x, y, styleR, styleL) {
	plotter.rect(0, 0, x, y, 0, 0, styleR);
	for (_ in 0...n)
		plotter.line(
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			styleL
		);
}

function randomLineE(plotter:PlotterE, n, x, y, styleR, styleL) {
	plotter.plot(Rect(0, 0, x, y, 0, 0, styleR));
	for (_ in 0...n)
		plotter.plot(Line(
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			Math.floor(Math.random() * 0xffffff) % x,
			Math.floor(Math.random() * 0xffffff) % y,
			styleL
		));
}
