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
//	SvgPlot					to	SvgPlotWithBuffering
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

private abstract class Base {
	var x:Int;
	var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	abstract public function move(x:Float, y:Float):Void;
	abstract public function moveRel(x:Float, y:Float):Void;
	abstract public function draw(x:Float, y:Float):Void;
	abstract public function drawRel(x:Float, y:Float):Void;
}

private abstract class BaseWriter extends Base {
	var fh:sys.io.FileOutput;

	abstract public function plotStart(fh:sys.io.FileOutput):Void;
	abstract public function plotEnd(isClosePath:Bool=false):Void;
}

private abstract class BaseWriterWithBuffering extends Base {
	var buf:StringBuf = new StringBuf();
	var isClosePath:Bool;

	abstract public function plotEnd(isClosePath:Bool=false):Void;
	abstract public function reset():Void;
	abstract public function write(fh:sys.io.FileOutput):Void;
}

class SvgPlot extends BaseWriter {
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

class SvgPlotWithBuffering extends BaseWriterWithBuffering {
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
	var s = if (isClosePath) "Z" else "";
	return '$s" fill="none" stroke="black" />
';
}

// workarounds for something like C-printf-"%g"-format
private function workarounds(n:Float):String {
	var d:Float = Math.pow(10, 4);
	return Std.string(Math.round(n * d) / d);
}

private function format(s:String, x:Float, y:Float):String {
	var xs:String = workarounds(x);
	var ys:String = workarounds(y);
	return '$s $xs $ys ';
}

//

private function sample(plotter) {
	for (i in 0...5) {
		var t:Float = 2 * Math.PI * i / 5;
		var x:Float = 150 + 140 * Math.cos(t);
		var y:Float = 150 + 140 * Math.sin(t);
		if (i == 0)
			plotter.move(x, y);
		else
			plotter.draw(x, y);
	}
}

private function demoA() {
	var path = "results/svgplot-hx.svg";

	Helper.with(path, (fh:sys.io.FileOutput) -> {
		var plotter = new SvgPlot(300, 300);
		plotter.plotStart(fh);
		sample(plotter);
		plotter.plotEnd(true);
	});
}

private function demoB() {
	var plotter = new SvgPlotWithBuffering(300, 300);
	sample(plotter);
	plotter.plotEnd(true);

	var path = "results/svgplot-hx-WB.svg";
	Helper.with(path, (fh:sys.io.FileOutput) -> {
		plotter.write(fh);
	});
}

function demo() {
	demoA();
	demoB();
}
