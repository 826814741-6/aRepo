//
//	from src/svgplot.c
//
//	void plot_start(int, int)	to	.plotStart, .pathStart / PathStart
//	void plot_end(int)		to	.plotEnd, .pathEnd / PathEnd
//	void move(double, double)	to	.move / Move
//	void move_rel(double, double)	to	.moveRel / MoveRel
//	void draw(double, double)	to	.draw / Draw
//	void draw_rel(double, double)	to	.drawRel / DrawRel
//
//	SvgPlot,SvgPlotWithBuffering		SvgPlotWholeBuffering
//
//	.plotStart
//	.plotEnd
//						.reset
//						.write
//

package src;

interface Plotter {
	public function pathStart():Void;
	public function pathEnd(isClosePath:Bool):Void;
	public function move(x:Float, y:Float):Void;
	public function moveRel(x:Float, y:Float):Void;
	public function draw(x:Float, y:Float):Void;
	public function drawRel(x:Float, y:Float):Void;
}

interface PlotterE {
	public function plot(method:Method):Void;
}

enum Method {
	PathStart;
	PathEnd(isClosePath:Bool);
	Move(x:Float, y:Float);
	MoveRel(x:Float, y:Float);
	Draw(x:Float, y:Float);
	DrawRel(x:Float, y:Float);
}

//

private class Base {
	final width:Int;
	final height:Int;

	public function new(w:Int, h:Int) {
		width = w;
		height = h;
	}
}

private class Writer extends Base {
	var fh:sys.io.FileOutput;

	public function plotStart(fh:sys.io.FileOutput) {
		this.fh = fh;
		this.fh.writeString(getHeader(width, height));
	}

	public function plotEnd() {
		fh.writeString(getFooter());
		fh = null;
	}
}

private class WriterWholeBuffering extends Base {
	var buf:StringBuf = new StringBuf();

	public function reset()
		buf = new StringBuf();

	public function write(fh:sys.io.FileOutput) {
		fh.writeString(getHeader(width, height));
		fh.writeString(buf.toString());
		fh.writeString(getFooter());
	}
}

private class WriterWithBuffering extends Base {
	var fh:sys.io.FileOutput;
	var buf:StringBuf;
	var counter:Int;
	var limit:Int;

	function writer() {
		counter += 1;
		if (counter >= limit) {
			fh.writeString(buf.toString());
			reset();
		}
	}

	function reset() {
		buf = new StringBuf();
		counter = 0;
	}

	public function plotStart(fh:sys.io.FileOutput, limit:Int=1) {
		reset();
		this.limit = limit;
		this.fh = fh;
		this.fh.writeString(getHeader(width, height));
	}

	public function plotEnd() {
		if (buf.length > 0) {
			fh.writeString(buf.toString());
		}
		fh.writeString(getFooter());
		fh = null;
		reset();
	}
}

//

class SvgPlot extends Writer implements Plotter {
	public function pathStart()
		fh.writeString(getPathStart());

	public function pathEnd(isClosePath:Bool)
		fh.writeString(getPathEnd(isClosePath));

	public function move(x:Float, y:Float)
		fh.writeString(format('M', x, height - y));

	public function moveRel(x:Float, y:Float)
		fh.writeString(format('m', x, -y));

	public function draw(x:Float, y:Float)
		fh.writeString(format('L', x, height - y));

	public function drawRel(x:Float, y:Float)
		fh.writeString(format('l', x, -y));
}

class SvgPlotE extends Writer implements PlotterE {
	public function plot(method:Method)
		switch (method) {
			case PathStart:
				fh.writeString(getPathStart());
			case PathEnd(isClosePath):
				fh.writeString(getPathEnd(isClosePath));
			case Move(x, y):
				fh.writeString(format('M', x, height - y));
			case MoveRel(x, y):
				fh.writeString(format('m', x, -y));
			case Draw(x, y):
				fh.writeString(format('L', x, height - y));
			case DrawRel(x, y):
				fh.writeString(format('l', x, -y));
		}
}

class SvgPlotWholeBuffering extends WriterWholeBuffering implements Plotter {
	public function pathStart()
		buf.add(getPathStart());

	public function pathEnd(isClosePath:Bool)
		buf.add(getPathEnd(isClosePath));

	public function move(x:Float, y:Float)
		buf.add(format('M', x, height - y));

	public function moveRel(x:Float, y:Float)
		buf.add(format('m', x, -y));

	public function draw(x:Float, y:Float)
		buf.add(format('L', x, height - y));

	public function drawRel(x:Float, y:Float)
		buf.add(format('l', x, -y));
}

class SvgPlotWholeBufferingE extends WriterWholeBuffering implements PlotterE {
	public function plot(method:Method)
		switch (method) {
			case PathStart:
				buf.add(getPathStart());
			case PathEnd(isClosePath):
				buf.add(getPathEnd(isClosePath));
			case Move(x, y):
				buf.add(format('M', x, height - y));
			case MoveRel(x, y):
				buf.add(format('m', x, -y));
			case Draw(x, y):
				buf.add(format('L', x, height - y));
			case DrawRel(x, y):
				buf.add(format('l', x, -y));
		}
}

class SvgPlotWithBuffering extends WriterWithBuffering implements Plotter {
	public function pathStart() {
		buf.add(getPathStart());
		writer();
	}

	public function pathEnd(isClosePath:Bool) {
		buf.add(getPathEnd(isClosePath));
		writer();
	}

	public function move(x:Float, y:Float) {
		buf.add(format('M', x, height - y));
		writer();
	}

	public function moveRel(x:Float, y:Float) {
		buf.add(format('m', x, -y));
		writer();
	}

	public function draw(x:Float, y:Float) {
		buf.add(format('L', x, height - y));
		writer();
	}

	public function drawRel(x:Float, y:Float) {
		buf.add(format('l', x, -y));
		writer();
	}
}

class SvgPlotWithBufferingE extends WriterWithBuffering implements PlotterE {
	public function plot(method:Method) {
		switch (method) {
			case PathStart:
				buf.add(getPathStart());
			case PathEnd(isClosePath):
				buf.add(getPathEnd(isClosePath));
			case Move(x, y):
				buf.add(format('M', x, height - y));
			case MoveRel(x, y):
				buf.add(format('m', x, -y));
			case Draw(x, y):
				buf.add(format('L', x, height - y));
			case DrawRel(x, y):
				buf.add(format('l', x, -y));
		}
		writer();
	}
}

//

private function getHeader(w:Int, h:Int):String
	return '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="$w" height="$h">
';

private function getFooter():String
	return '</svg>
';

private function getPathStart():String
	return '<path d="';

private function getPathEnd(isClosePath:Bool):String {
	return '${if (isClosePath) "Z" else ""}" fill="none" stroke="black" />
';
}

// workarounds for something like C-printf-"%g"-format
private function workarounds(n:Float):String {
	final d:Float = Math.pow(10, 4);
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
