//
//	from src/lissaj.c
//
//	a part of main		to	lissajousCurve / lissajousCurveE
//

package src;

using src.SvgPlot;

function lissajousCurve(plotter:Plotter, n:Int, offset:Int):Plotter {
	loop(plotter, n, offset);
	return plotter;
}

function lissajousCurveE(plotter:PlotterE, n:Int, offset:Int):PlotterE {
	loopE(plotter, n, offset);
	return plotter;
}

private inline function stepX(n:Int, offset:Int, x:Float):Float
	return n + offset + n * Math.cos(x);

private inline function stepY(n:Int, offset:Int, y:Float):Float
	return n + offset + n * Math.sin(y);

private function loop(plotter:Plotter, n:Int, offset:Int) {
	plotter.move(stepX(n, offset, 0), stepY(n, offset, 0));
	for (i in 1...361)
		plotter.draw(
			stepX(n, offset, 3 * (Math.PI / 180) * i),
			stepY(n, offset, 5 * (Math.PI / 180) * i)
		);
}

private function loopE(plotter:PlotterE, n:Int, offset:Int) {
	plotter.plot(Move(stepX(n, offset, 0), stepY(n, offset, 0)));
	for (i in 1...361)
		plotter.plot(Draw(
			stepX(n, offset, 3 * (Math.PI / 180) * i),
			stepY(n, offset, 5 * (Math.PI / 180) * i)
		));
}
