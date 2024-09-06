//
//	from src/lissaj.c
//
//	a part of main		to	lissajousCurve / lissajousCurveE
//

package src;

private inline function stepX(n:Int, offset:Int, x:Float):Float
	return n + offset + n * Math.cos(x);

private inline function stepY(n:Int, offset:Int, y:Float):Float
	return n + offset + n * Math.sin(y);

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
