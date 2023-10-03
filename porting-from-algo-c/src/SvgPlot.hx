//
//	from src/svgplot.c
//
//	void plot_start(int, int)		to	.plotStart
//	void plot_end(int)			to	.plotEnd
//	void move(double, double)		to	.move
//	void move_rel(double, double)		to	.moveRel
//	void draw(double, double)		to	.draw
//	void draw_rel(double, double)		to	.drawRel
//
//	SvgPlot,SvgPlotWithBuffering		to	SvgPlotWholeBuffering
//	.plotStart
//	.plotEnd				to	[.plotEnd]
//	.move					to	.move
//	.moveRel				to	.moveRel
//	.draw					to	.draw
//	.drawRel				to	.drawRel
//							.reset
//							.write
//

package src;

interface Plotter {
	public function move(x:Float, y:Float):Void;
	public function moveRel(x:Float, y:Float):Void;
	public function draw(x:Float, y:Float):Void;
	public function drawRel(x:Float, y:Float):Void;
}

//

private abstract class Base implements Plotter {
	var x:Int;
	var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
}

private abstract class Writer extends Base {
	var fh:sys.io.FileOutput;

	abstract public function plotStart(fh:sys.io.FileOutput):Void;
	abstract public function plotEnd(isClosePath:Bool=false):Void;
}

private abstract class WriterWholeBuffering extends Base {
	var buf:StringBuf = new StringBuf();
	var isClosePath:Bool = false;

	abstract public function plotEnd(isClosePath:Bool=false):Void;
	abstract public function reset():Void;
	abstract public function write(fh:sys.io.FileOutput):Void;
}

private abstract class WriterWithBuffering extends Base {
	var fh:sys.io.FileOutput;
	var buf:StringBuf;
	var counter:Int;
	var limit:Int;

	abstract public function plotStart(fh:sys.io.FileOutput, limit:Int=1):Void;
	abstract public function plotEnd(isClosePath:Bool=false):Void;
}

//

class SvgPlot extends Writer {
	public function plotStart(fh:sys.io.FileOutput) {
		this.fh = fh;
		this.fh.writeString(header(this.x, this.y));
		this.fh.writeString(pathStart());
	}

	public function plotEnd(isClosePath:Bool=false) {
		this.fh.writeString(pathEnd(isClosePath));
		this.fh.writeString(footer());
		this.fh = null;
	}

	public function move(x:Float, y:Float) {
		this.fh.writeString(format('M', x, this.y - y));
	}

	public function moveRel(x:Float, y:Float) {
		this.fh.writeString(format('m', x, -y));
	}

	public function draw(x:Float, y:Float) {
		this.fh.writeString(format('L', x, this.y - y));
	}

	public function drawRel(x:Float, y:Float) {
		this.fh.writeString(format('l', x, -y));
	}
}

class SvgPlotWholeBuffering extends WriterWholeBuffering {
	public function plotEnd(isClosePath:Bool=false) {
		this.isClosePath = isClosePath;
	}

	public function move(x:Float, y:Float) {
		this.buf.add(format('M', x, this.y - y));
	}

	public function moveRel(x:Float, y:Float) {
		this.buf.add(format('m', x, -y));
	}

	public function draw(x:Float, y:Float) {
		this.buf.add(format('L', x, this.y - y));
	}

	public function drawRel(x:Float, y:Float) {
		this.buf.add(format('l', x, -y));
	}

	public function reset() {
		this.buf = new StringBuf();
	}

	public function write(fh:sys.io.FileOutput) {
		fh.writeString(header(this.x, this.y));
		fh.writeString(pathStart());
		fh.writeString(this.buf.toString());
		fh.writeString(pathEnd(this.isClosePath));
		fh.writeString(footer());
	}
}

class SvgPlotWithBuffering extends WriterWithBuffering {
	function writer() {
		this.counter += 1;
		if (this.counter >= this.limit) {
			this.fh.writeString(this.buf.toString());
			reset();
		}
	}

	function reset() {
		this.buf = new StringBuf();
		this.counter = 0;
	}

	public function plotStart(fh:sys.io.FileOutput, limit:Int=1) {
		reset();
		this.limit = limit;
		this.fh = fh;
		this.fh.writeString(header(this.x, this.y));
		this.fh.writeString(pathStart());
	}

	public function plotEnd(isClosePath:Bool=false) {
		if (this.buf.length > 0) {
			this.fh.writeString(this.buf.toString());
		}
		this.fh.writeString(pathEnd(isClosePath));
		this.fh.writeString(footer());
		this.fh = null;
		this.limit = 1;
		reset();
	}

	public function move(x:Float, y:Float) {
		this.buf.add(format('M', x, this.y - y));
		writer();
	}

	public function moveRel(x:Float, y:Float) {
		this.buf.add(format('m', x, -y));
		writer();
	}

	public function draw(x:Float, y:Float) {
		this.buf.add(format('L', x, this.y - y));
		writer();
	}

	public function drawRel(x:Float, y:Float) {
		this.buf.add(format('l', x, -y));
		writer();
	}
}

private function header(x:Int, y:Int):String {
	return '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="$x" height="$y">
';
}

private function footer():String {
	return '</svg>
';
}

private function pathStart():String {
	return '<path d="';
}

private function pathEnd(isClosePath:Bool):String {
	return '${if (isClosePath) "Z" else ""}" fill="none" stroke="black" />
';
}

// workarounds for something like C-printf-"%g"-format
private function workarounds(n:Float):String {
	var d:Float = Math.pow(10, 4);
	return Std.string(Math.round(n * d) / d);
}

private function format(s:String, x:Float, y:Float):String {
	return '$s ${workarounds(x)} ${workarounds(y)} ';
}

//

private function sample(plotter:Plotter) {
	for (i in 0...5) {
		final t:Float = 2 * Math.PI * i / 5;
		final x:Float = 150 + 140 * Math.cos(t);
		final y:Float = 150 + 140 * Math.sin(t);
		if (i == 0)
			plotter.move(x, y);
		else
			plotter.draw(x, y);
	}
}

//

private function demoA(path) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlot(300, 300);

		plotter.plotStart(fh);
		sample(plotter);
		plotter.plotEnd(true);
	});
}

private function demoB(path) {
	var plotter = new SvgPlotWholeBuffering(300, 300);

	sample(plotter);
	plotter.plotEnd(true);

	Helper.withFileWrite(path, (fh) -> plotter.write(fh));
}

private function demoC(path) {
	Helper.withFileWrite(path, (fh) -> {
		var plotter = new SvgPlotWithBuffering(300, 300);

		plotter.plotStart(fh, 2);
		sample(plotter);
		plotter.plotEnd(true);
	});
}

function demo() {
	demoA("results/svgplot-hx.svg");
	demoB("results/svgplot-hx-WB-A.svg");
	demoC("results/svgplot-hx-WB-B.svg");
}
