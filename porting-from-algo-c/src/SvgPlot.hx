//
//	from src/svgplot.c
//
//	void plot_start(int, int)		to	.plotStart
//	void plot_end(int)			to	.plotEnd
//	void move(double, double)		to	.move / Move
//	void move_rel(double, double)		to	.moveRel / MoveRel
//	void draw(double, double)		to	.draw / Draw
//	void draw_rel(double, double)		to	.drawRel / DrawRel
//
//	SvgPlot,SvgPlotWithBuffering			SvgPlotWholeBuffering
//
//	.plotStart
//	.plotEnd					[.plotEnd]
//							.reset
//							.write
//
//	.move / Move					.move / Move
//	.moveRel / MoveRel				.moveRel / MoveRel
//	.draw / Draw					.draw / Draw
//	.drawRel / DrawRel				.drawRel / DrawRel
//

package src;

interface Plotter {
	public function move(x:Float, y:Float):Void;
	public function moveRel(x:Float, y:Float):Void;
	public function draw(x:Float, y:Float):Void;
	public function drawRel(x:Float, y:Float):Void;
}

interface PlotterE {
	public function plot(method:Method):Void;
}

enum Method {
	Move(x:Float, y:Float);
	MoveRel(x:Float, y:Float);
	Draw(x:Float, y:Float);
	DrawRel(x:Float, y:Float);
}

//

private class Base {
	var x:Int;
	var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
}

private class Writer extends Base {
	var fh:sys.io.FileOutput;

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
}

private class WriterWholeBuffering extends Base {
	var buf:StringBuf = new StringBuf();
	var isClosePath:Bool = false;

	public function plotEnd(isClosePath:Bool=false)
		this.isClosePath = isClosePath;

	public function reset()
		this.buf = new StringBuf();

	public function write(fh:sys.io.FileOutput) {
		fh.writeString(header(this.x, this.y));
		fh.writeString(pathStart());
		fh.writeString(this.buf.toString());
		fh.writeString(pathEnd(this.isClosePath));
		fh.writeString(footer());
	}
}

private class WriterWithBuffering extends Base {
	var fh:sys.io.FileOutput;
	var buf:StringBuf;
	var counter:Int;
	var limit:Int;

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
}

//

class SvgPlot extends Writer implements Plotter {
	public function move(x:Float, y:Float)
		this.fh.writeString(format('M', x, this.y - y));

	public function moveRel(x:Float, y:Float)
		this.fh.writeString(format('m', x, -y));

	public function draw(x:Float, y:Float)
		this.fh.writeString(format('L', x, this.y - y));

	public function drawRel(x:Float, y:Float)
		this.fh.writeString(format('l', x, -y));
}

class SvgPlotE extends Writer implements PlotterE {
	public function plot(method:Method)
		switch (method) {
			case Move(x, y):
				this.fh.writeString(format('M', x, this.y - y));
			case MoveRel(x, y):
				this.fh.writeString(format('m', x, -y));
			case Draw(x, y):
				this.fh.writeString(format('L', x, this.y - y));
			case DrawRel(x, y):
				this.fh.writeString(format('l', x, -y));
		}
}

class SvgPlotWholeBuffering extends WriterWholeBuffering implements Plotter {
	public function move(x:Float, y:Float)
		this.buf.add(format('M', x, this.y - y));

	public function moveRel(x:Float, y:Float)
		this.buf.add(format('m', x, -y));

	public function draw(x:Float, y:Float)
		this.buf.add(format('L', x, this.y - y));

	public function drawRel(x:Float, y:Float)
		this.buf.add(format('l', x, -y));
}

class SvgPlotWholeBufferingE extends WriterWholeBuffering implements PlotterE {
	public function plot(method:Method)
		switch (method) {
			case Move(x, y):
				this.buf.add(format('M', x, this.y - y));
			case MoveRel(x, y):
				this.buf.add(format('m', x, -y));
			case Draw(x, y):
				this.buf.add(format('L', x, this.y - y));
			case DrawRel(x, y):
				this.buf.add(format('l', x, -y));
		}
}

class SvgPlotWithBuffering extends WriterWithBuffering implements Plotter {
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

class SvgPlotWithBufferingE extends WriterWithBuffering implements PlotterE {
	public function plot(method:Method)
		switch (method) {
			case Move(x, y):
				this.buf.add(format('M', x, this.y - y));
				writer();
			case MoveRel(x, y):
				this.buf.add(format('m', x, -y));
				writer();
			case Draw(x, y):
				this.buf.add(format('L', x, this.y - y));
				writer();
			case DrawRel(x, y):
				this.buf.add(format('l', x, -y));
				writer();
		}
}

//

private function header(x:Int, y:Int):String
	return '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="$x" height="$y">
';

private function footer():String
	return '</svg>
';

private function pathStart():String
	return '<path d="';

private function pathEnd(isClosePath:Bool):String
	return '${if (isClosePath) "Z" else ""}" fill="none" stroke="black" />
';

// workarounds for something like C-printf-"%g"-format
private function workarounds(n:Float):String {
	var d:Float = Math.pow(10, 4);
	return Std.string(Math.round(n * d) / d);
}

private function format(s:String, x:Float, y:Float):String
	return '$s ${workarounds(x)} ${workarounds(y)} ';

//

function sample(plotter:Plotter)
	for (i in 0...5) {
		final t:Float = 2 * Math.PI * i / 5;
		final x:Float = 150 + 140 * Math.cos(t);
		final y:Float = 150 + 140 * Math.sin(t);
		if (i == 0)
			plotter.move(x, y);
		else
			plotter.draw(x, y);
	}

function sampleE(plotter:PlotterE)
	for (i in 0...5) {
		final t:Float = 2 * Math.PI * i / 5;
		final x:Float = 150 + 140 * Math.cos(t);
		final y:Float = 150 + 140 * Math.sin(t);
		if (i == 0)
			plotter.plot(Move(x, y));
		else
			plotter.plot(Draw(x, y));
	}
