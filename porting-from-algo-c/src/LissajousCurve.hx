//
//	from src/lissaj.c
//
//	a part of main		to	lissajousCurve
//

package src;

private function stepX(n:Int, offset:Int, x:Float):Float {
	return n + offset + n * Math.cos(x);
}

private function stepY(n:Int, offset:Int, y:Float):Float {
	return n + offset + n * Math.sin(y);
}

function lissajousCurve(plotter:SvgPlot.Base, n:Int, offset:Int) {
	plotter.move(stepX(n, offset, 0), stepY(n, offset, 0));
	for (i in 1...361)
		plotter.draw(
			stepX(n, offset, 3 * (Math.PI / 180) * i),
			stepY(n, offset, 5 * (Math.PI / 180) * i)
		);
}

//

private function demoA(n, offset) {
	var path = "results/lissajouscurve-hx.svg";

	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot.SvgPlot((n + offset) * 2, (n + offset) * 2);
		plotter.plotStart(fh);
		lissajousCurve(plotter, n, offset);
		plotter.plotEnd(true);
	});
}

private function demoB(n, offset) {
	var plotter = new SvgPlot.SvgPlotWithBuffering((n + offset) * 2, (n + offset) * 2);
	lissajousCurve(plotter, n, offset);
	plotter.plotEnd(true);

	var path = "results/lissajouscurve-hx-WB.svg";
	Helper.withFileWrite(path, (fh) -> plotter.write(fh));
}

function demo() {
	var n = 300;
	var offset = 10;

	demoA(n, offset);
	demoB(n, offset);
}
