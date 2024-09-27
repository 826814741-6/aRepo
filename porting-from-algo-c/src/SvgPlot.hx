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
	//
	public function circle(cx:Float, cy:Float, r:Float, style:StyleMaker):Void;
	public function ellipse(cx:Float, cy:Float, rx:Float, ry:Float, style:StyleMaker):Void;
	public function line(x1:Float, y1:Float, x2:Float, y2:Float, style:StyleMaker):Void;
	public function rect(x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float, style:StyleMaker):Void;
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
	//
	Circle(cx:Float, cy:Float, r:Float, style:StyleMaker);
	Ellipse(cx:Float, cy:Float, rx:Float, ry:Float, style:StyleMaker);
	Line(x1:Float, y1:Float, x2:Float, y2:Float, style:StyleMaker);
	Rect(x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float, style:StyleMaker);
}

enum Style {
	Fill(c:Color);
	PaintOrder(s:String);
	Stroke(c:Color);
	StrokeWidth(n:Float);
}

enum Color {
	Transparent;
	Black;
	White;
	RandomRGB;
	Raw(s:String);
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
		this.fh.writeString(fmtHeader(width, height));
	}

	public function plotEnd() {
		fh.writeString(fmtFooter());
		fh = null;
	}
}

private class WriterWholeBuffering extends Base {
	var buf:StringBuf = new StringBuf();

	public function reset()
		buf = new StringBuf();

	public function write(fh:sys.io.FileOutput) {
		fh.writeString(fmtHeader(width, height));
		fh.writeString(buf.toString());
		fh.writeString(fmtFooter());
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
		this.fh.writeString(fmtHeader(width, height));
	}

	public function plotEnd() {
		if (buf.length > 0) {
			fh.writeString(buf.toString());
		}
		fh.writeString(fmtFooter());
		fh = null;
		reset();
	}
}

//

class SvgPlot extends Writer implements Plotter {
	public function pathStart()
		fh.writeString(fmtPathStart());

	public function pathEnd(isClosePath:Bool)
		fh.writeString(fmtPathEnd(isClosePath));

	public function move(x:Float, y:Float)
		fh.writeString(format('M', x, height - y));

	public function moveRel(x:Float, y:Float)
		fh.writeString(format('m', x, -y));

	public function draw(x:Float, y:Float)
		fh.writeString(format('L', x, height - y));

	public function drawRel(x:Float, y:Float)
		fh.writeString(format('l', x, -y));

	public function circle(cx, cy, r, style)
		fh.writeString(fmtCircle(cx, cy, r, style));

	public function ellipse(cx, cy, rx, ry, style)
		fh.writeString(fmtEllipse(cx, cy, rx, ry, style));

	public function line(x1, y1, x2, y2, style)
		fh.writeString(fmtLine(x1, y1, x2, y2, style));

	public function rect(x, y, w, h, rx, ry, style)
		fh.writeString(fmtRect(x, y, w, h, rx, ry, style));
}

class SvgPlotE extends Writer implements PlotterE {
	public function plot(method:Method)
		fh.writeString(switch (method) {
			case PathStart:
				fmtPathStart();
			case PathEnd(isClosePath):
				fmtPathEnd(isClosePath);
			case Move(x, y):
				format('M', x, height - y);
			case MoveRel(x, y):
				format('m', x, -y);
			case Draw(x, y):
				format('L', x, height - y);
			case DrawRel(x, y):
				format('l', x, -y);
			case Circle(cx, cy, r, style):
				fmtCircle(cx, cy, r, style);
			case Ellipse(cx, cy, rx, ry, style):
				fmtEllipse(cx, cy, rx, ry, style);
			case Line(x1, y1, x2, y2, style):
				fmtLine(x1, y1, x2, y2, style);
			case Rect(x, y, w, h, rx, ry, style):
				fmtRect(x, y, w, h, rx, ry, style);
		});
}

class SvgPlotWholeBuffering extends WriterWholeBuffering implements Plotter {
	public function pathStart()
		buf.add(fmtPathStart());

	public function pathEnd(isClosePath:Bool)
		buf.add(fmtPathEnd(isClosePath));

	public function move(x:Float, y:Float)
		buf.add(format('M', x, height - y));

	public function moveRel(x:Float, y:Float)
		buf.add(format('m', x, -y));

	public function draw(x:Float, y:Float)
		buf.add(format('L', x, height - y));

	public function drawRel(x:Float, y:Float)
		buf.add(format('l', x, -y));

	public function circle(cx, cy, r, style)
		buf.add(fmtCircle(cx, cy, r, style));

	public function ellipse(cx, cy, rx, ry, style)
		buf.add(fmtEllipse(cx, cy, rx, ry, style));

	public function line(x1, y1, x2, y2, style)
		buf.add(fmtLine(x1, y1, x2, y2, style));

	public function rect(x, y, w, h, rx, ry, style)
		buf.add(fmtRect(x, y, w, h, rx, ry, style));
}

class SvgPlotWholeBufferingE extends WriterWholeBuffering implements PlotterE {
	public function plot(method:Method)
		buf.add(switch (method) {
			case PathStart:
				fmtPathStart();
			case PathEnd(isClosePath):
				fmtPathEnd(isClosePath);
			case Move(x, y):
				format('M', x, height - y);
			case MoveRel(x, y):
				format('m', x, -y);
			case Draw(x, y):
				format('L', x, height - y);
			case DrawRel(x, y):
				format('l', x, -y);
			case Circle(cx, cy, r, style):
				fmtCircle(cx, cy, r, style);
			case Ellipse(cx, cy, rx, ry, style):
				fmtEllipse(cx, cy, rx, ry, style);
			case Line(x1, y1, x2, y2, style):
				fmtLine(x1, y1, x2, y2, style);
			case Rect(x, y, w, h, rx, ry, style):
				fmtRect(x, y, w, h, rx, ry, style);
		});
}

class SvgPlotWithBuffering extends WriterWithBuffering implements Plotter {
	public function pathStart() {
		buf.add(fmtPathStart());
		writer();
	}

	public function pathEnd(isClosePath:Bool) {
		buf.add(fmtPathEnd(isClosePath));
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

	public function circle(cx, cy, r, style) {
		buf.add(fmtCircle(cx, cy, r, style));
		writer();
	}

	public function ellipse(cx, cy, rx, ry, style) {
		buf.add(fmtEllipse(cx, cy, rx, ry, style));
		writer();
	}

	public function line(x1, y1, x2, y2, style) {
		buf.add(fmtLine(x1, y1, x2, y2, style));
		writer();
	}

	public function rect(x, y, w, h, rx, ry, style) {
		buf.add(fmtRect(x, y, w, h, rx, ry, style));
		writer();
	}
}

class SvgPlotWithBufferingE extends WriterWithBuffering implements PlotterE {
	public function plot(method:Method) {
		buf.add(switch (method) {
			case PathStart:
				fmtPathStart();
			case PathEnd(isClosePath):
				fmtPathEnd(isClosePath);
			case Move(x, y):
				format('M', x, height - y);
			case MoveRel(x, y):
				format('m', x, -y);
			case Draw(x, y):
				format('L', x, height - y);
			case DrawRel(x, y):
				format('l', x, -y);
			case Circle(cx, cy, r, style):
				fmtCircle(cx, cy, r, style);
			case Ellipse(cx, cy, rx, ry, style):
				fmtEllipse(cx, cy, rx, ry, style);
			case Line(x1, y1, x2, y2, style):
				fmtLine(x1, y1, x2, y2, style);
			case Rect(x, y, w, h, rx, ry, style):
				fmtRect(x, y, w, h, rx, ry, style);
		});
		writer();
	}
}

//

class StyleMaker {
	final buf:List<() -> String>;
	final tag:Map<String, Bool>;

	public function new() {
		buf = new List<() -> String>();
		tag = new Map<String, Bool>();
	}

	public function get():String
		return buf.map(e -> e()).join(' ');

	public function add(style:Style):StyleMaker {
		final t = getTag(style);
		if (!tag.exists(t)) {
			tag[t] = true;
			buf.add(fmtStyle(style));
		}
		return this;
	}

	function getTag(style:Style):String
		return switch(style) {
			case Fill(c):
				'Fill';
			case PaintOrder(s):
				'PointOrder';
			case Stroke(c):
				'Stroke';
			case StrokeWidth(n):
				'StrokeWidth';
		};
}

//

private function fmtHeader(w:Int, h:Int):String
	return '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="$w" height="$h">
';

private function fmtFooter():String
	return '</svg>
';

private function fmtPathStart():String
	return '<path d="';

private function fmtPathEnd(isClosePath:Bool):String
	return '${if (isClosePath) "Z" else ""}" fill="none" stroke="black" />
';

private function fmtCircle(cx:Float, cy:Float, r:Float, style:StyleMaker)
	return '<circle cx="$cx" cy="$cy" r="$r" ${style.get()}/>
';

private function fmtEllipse(cx:Float, cy:Float, rx:Float, ry:Float, style:StyleMaker)
	return '<ellipse cx="$cx" cy="$cy" rx="$rx" ry="$ry" ${style.get()}/>
';

private function fmtLine(x1:Float, y1:Float, x2:Float, y2:Float, style:StyleMaker)
	return '<line x1="$x1" y1="$y1" x2="$x2" y2="$y2" ${style.get()}/>
';

private function fmtRect(x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float, style:StyleMaker)
	return '<rect x="$x" y="$y" width="$w" height="$h" rx="$rx" ry="$rx" ${style.get()}/>
';

// workarounds for something like C-printf-"%g"-format
private function workarounds(n:Float):String {
	final d:Float = Math.pow(10, 4);
	return Std.string(Math.round(n * d) / d);
}

private function format(s:String, x:Float, y:Float):String
	return '$s ${workarounds(x)} ${workarounds(y)} ';

private function fmtStyle(style:Style):() -> String
	return switch (style) {
		case Fill(c):
			() -> 'fill="${fmtColor(c)}"';
		case PaintOrder(s):
			() -> 'paint-order="$s"';
		case Stroke(c):
			() -> 'stroke="${fmtColor(c)}"';
		case StrokeWidth(n):
			() -> 'stroke-width="$n"';
	};

private function fmtColor(c:Color):String
	return switch (c) {
		case Transparent:
			'transparent';
		case Black:
			'black';
		case White:
			'white';
		case RandomRGB:
			final i = Math.floor(Math.random() * 0xFFFFFF);
			'rgb(${i >> 16} ${(i >> 8) & 0xFF} ${i & 0xFF})';
		case Raw(s):
			s;
	};

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
