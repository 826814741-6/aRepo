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
//	SvgPlot,SvgPlotWithBuffer		SvgPlotWholeBuffer
//
//	.plotStart
//	.plotEnd
//						.reset
//						.write
//
//	and some extensions for basic shapes	.circle / Circle, .ellipse / Ellipse,
//						.line / Line, .rect / Rect
//

package src;

interface Plotter {
	public function pathStart():Plotter;
	public function pathEnd(isClosePath:Bool, style:StyleMaker):Plotter;
	public function move(x:Float, y:Float):Plotter;
	public function moveRel(x:Float, y:Float):Plotter;
	public function draw(x:Float, y:Float):Plotter;
	public function drawRel(x:Float, y:Float):Plotter;
	//
	public function circle(cx:Float, cy:Float, r:Float, style:StyleMaker):Plotter;
	public function ellipse(cx:Float, cy:Float, rx:Float, ry:Float, style:StyleMaker):Plotter;
	public function line(x1:Float, y1:Float, x2:Float, y2:Float, style:StyleMaker):Plotter;
	public function rect(x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float, style:StyleMaker):Plotter;
}

interface PlotterE {
	public function plot(method:Method):PlotterE;
}

enum Method {
	PathStart;
	PathEnd(isClosePath:Bool, style:StyleMaker);
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
	None;
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

private class WriterWholeBuffer extends Base {
	var buf:StringBuf = new StringBuf();

	public function reset()
		buf = new StringBuf();

	public function write(fh:sys.io.FileOutput) {
		fh.writeString(fmtHeader(width, height));
		fh.writeString(buf.toString());
		fh.writeString(fmtFooter());
	}
}

private class WriterWithBuffer extends Base {
	var fh:sys.io.FileOutput;
	var buf:StringBuf;
	var counter:Int;
	var limit:Int;

	public function plotStart(fh:sys.io.FileOutput, limit:Int=10) {
		this.fh = fh;
		this.limit = limit;
		reset();
		writer(fmtHeader(width, height));
	}

	public function plotEnd() {
		writer(fmtFooter());
		tailStep();
		reset();
		fh = null;
	}

	function reset() {
		buf = new StringBuf();
		counter = 0;
	}

	function tailStep()
		if (buf.length > 0) {
			fh.writeString(buf.toString());
		}

	function writer(s:String) {
		buf.add(s);
		counter += 1;
		if (counter >= limit) {
			fh.writeString(buf.toString());
			reset();
		}
	}
}

//

class SvgPlot extends Writer implements Plotter {
	public function pathStart() {
		fh.writeString(fmtPathStart());
		return this;
	}

	public function pathEnd(isClosePath:Bool, style:StyleMaker) {
		fh.writeString(fmtPathEnd(isClosePath, style));
		return this;
	}

	public function move(x:Float, y:Float) {
		fh.writeString(fmtMove(x, y, height));
		return this;
	}

	public function moveRel(x:Float, y:Float) {
		fh.writeString(fmtMoveRel(x, y));
		return this;
	}

	public function draw(x:Float, y:Float) {
		fh.writeString(fmtDraw(x, y, height));
		return this;
	}

	public function drawRel(x:Float, y:Float) {
		fh.writeString(fmtDrawRel(x, y));
		return this;
	}

	public function circle(cx, cy, r, style) {
		fh.writeString(fmtCircle(cx, cy, r, style));
		return this;
	}

	public function ellipse(cx, cy, rx, ry, style) {
		fh.writeString(fmtEllipse(cx, cy, rx, ry, style));
		return this;
	}

	public function line(x1, y1, x2, y2, style) {
		fh.writeString(fmtLine(x1, y1, x2, y2, style));
		return this;
	}

	public function rect(x, y, w, h, rx, ry, style) {
		fh.writeString(fmtRect(x, y, w, h, rx, ry, style));
		return this;
	}
}

class SvgPlotE extends Writer implements PlotterE {
	public function plot(method:Method):PlotterE {
		fh.writeString(fmtMethod(method, height));
		return this;
	}
}

class SvgPlotWholeBuffer extends WriterWholeBuffer implements Plotter {
	public function pathStart() {
		buf.add(fmtPathStart());
		return this;
	}

	public function pathEnd(isClosePath:Bool, style:StyleMaker) {
		buf.add(fmtPathEnd(isClosePath, style));
		return this;
	}

	public function move(x:Float, y:Float) {
		buf.add(fmtMove(x, y, height));
		return this;
	}

	public function moveRel(x:Float, y:Float) {
		buf.add(fmtMoveRel(x, y));
		return this;
	}

	public function draw(x:Float, y:Float) {
		buf.add(fmtDraw(x, y, height));
		return this;
	}

	public function drawRel(x:Float, y:Float) {
		buf.add(fmtDrawRel(x, y));
		return this;
	}

	public function circle(cx, cy, r, style) {
		buf.add(fmtCircle(cx, cy, r, style));
		return this;
	}

	public function ellipse(cx, cy, rx, ry, style) {
		buf.add(fmtEllipse(cx, cy, rx, ry, style));
		return this;
	}

	public function line(x1, y1, x2, y2, style) {
		buf.add(fmtLine(x1, y1, x2, y2, style));
		return this;
	}

	public function rect(x, y, w, h, rx, ry, style) {
		buf.add(fmtRect(x, y, w, h, rx, ry, style));
		return this;
	}
}

class SvgPlotWholeBufferE extends WriterWholeBuffer implements PlotterE {
	public function plot(method:Method):PlotterE {
		buf.add(fmtMethod(method, height));
		return this;
	}
}

class SvgPlotWithBuffer extends WriterWithBuffer implements Plotter {
	public function pathStart() {
		writer(fmtPathStart());
		return this;
	}

	public function pathEnd(isClosePath:Bool, style:StyleMaker) {
		writer(fmtPathEnd(isClosePath, style));
		return this;
	}

	public function move(x:Float, y:Float) {
		writer(fmtMove(x, y, height));
		return this;
	}

	public function moveRel(x:Float, y:Float) {
		writer(fmtMoveRel(x, y));
		return this;
	}

	public function draw(x:Float, y:Float) {
		writer(fmtDraw(x, y, height));
		return this;
	}

	public function drawRel(x:Float, y:Float) {
		writer(fmtDrawRel(x, y));
		return this;
	}

	public function circle(cx, cy, r, style) {
		writer(fmtCircle(cx, cy, r, style));
		return this;
	}

	public function ellipse(cx, cy, rx, ry, style) {
		writer(fmtEllipse(cx, cy, rx, ry, style));
		return this;
	}

	public function line(x1, y1, x2, y2, style) {
		writer(fmtLine(x1, y1, x2, y2, style));
		return this;
	}

	public function rect(x, y, w, h, rx, ry, style) {
		writer(fmtRect(x, y, w, h, rx, ry, style));
		return this;
	}
}

class SvgPlotWithBufferE extends WriterWithBuffer implements PlotterE {
	public function plot(method:Method):PlotterE {
		writer(fmtMethod(method, height));
		return this;
	}
}

//

private function fmtMethod(method:Method, height:Int):String
	return switch (method) {
		case PathStart:
			fmtPathStart();
		case PathEnd(isClosePath, style):
			fmtPathEnd(isClosePath, style);
		case Move(x, y):
			fmtMove(x, y, height);
		case MoveRel(x, y):
			fmtMoveRel(x, y);
		case Draw(x, y):
			fmtDraw(x, y, height);
		case DrawRel(x, y):
			fmtDrawRel(x, y);
		case Circle(cx, cy, r, style):
			fmtCircle(cx, cy, r, style);
		case Ellipse(cx, cy, rx, ry, style):
			fmtEllipse(cx, cy, rx, ry, style);
		case Line(x1, y1, x2, y2, style):
			fmtLine(x1, y1, x2, y2, style);
		case Rect(x, y, w, h, rx, ry, style):
			fmtRect(x, y, w, h, rx, ry, style);
	};

private function fmtHeader(w:Int, h:Int):String
	return '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="$w" height="$h">
';

private function fmtFooter():String
	return '</svg>
';

private function fmtPathStart():String
	return '<path d="';

private function fmtPathEnd(isClosePath:Bool, style:StyleMaker):String
	return '${if (isClosePath) "Z" else ""}" ${style.get()}/>
';

private function fmtCircle(cx:Float, cy:Float, r:Float, style:StyleMaker):String
	return '<circle cx="$cx" cy="$cy" r="$r" ${style.get()}/>
';

private function fmtEllipse(cx:Float, cy:Float, rx:Float, ry:Float, style:StyleMaker):String
	return '<ellipse cx="$cx" cy="$cy" rx="$rx" ry="$ry" ${style.get()}/>
';

private function fmtLine(x1:Float, y1:Float, x2:Float, y2:Float, style:StyleMaker):String
	return '<line x1="$x1" y1="$y1" x2="$x2" y2="$y2" ${style.get()}/>
';

private function fmtRect(x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float, style:StyleMaker):String
	return '<rect x="$x" y="$y" width="$w" height="$h" rx="$rx" ry="$rx" ${style.get()}/>
';

// workaround for something like C-printf-"%g"-format
private function workaround(n:Float):String {
	final d:Float = Math.pow(10, 4);
	return Std.string(Math.round(n * d) / d);
}

private function fmtMove(x:Float, y:Float, height:Int):String
	return 'M ${workaround(x)} ${workaround(height - y)} ';

private function fmtMoveRel(x:Float, y:Float):String
	return 'm ${workaround(x)} ${workaround(-y)} ';

private function fmtDraw(x:Float, y:Float, height:Int):String
	return 'L ${workaround(x)} ${workaround(height - y)} ';

private function fmtDrawRel(x:Float, y:Float):String
	return 'l ${workaround(x)} ${workaround(-y)} ';

//

class StyleMaker {
	final buf:List<() -> String>;
	final attr:Map<Int, Bool>;

	public function new() {
		buf = new List<() -> String>();
		attr = new Map<Int, Bool>();
	}

	public function get():String
		return buf.map(e -> e()).join(' ');

	public function add(style:Style):StyleMaker {
		final k = getKey(style);
		if (!attr.exists(k)) {
			attr[k] = true;
			buf.add(fmtStyle(style));
		}
		return this;
	}

	function getKey(style:Style):Int
		return Type.enumIndex(style);
}

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
		case None:
			'none';
		case Transparent:
			'transparent';
		case Black:
			'black';
		case White:
			'white';
		case RandomRGB:
			final i = Math.floor(Math.random() * 0xffffff);
			'rgb(${i >> 16} ${(i >> 8) & 0xff} ${i & 0xff})';
		case Raw(s):
			s;
	};

//

function sample(plotter:Plotter, n:Int, offset:Int):Plotter {
	loop(plotter, n, offset);
	return plotter;
}

function sampleE(plotter:PlotterE, n:Int, offset:Int):PlotterE {
	loopE(plotter, n, offset);
	return plotter;
}

private function loop(plotter:Plotter, n:Int, offset:Int)
	for (i in 0...5) {
		final t:Float = 2 * Math.PI * i / 5;
		final x:Float = n / 2 + (n / 2 - offset) * Math.cos(t);
		final y:Float = n / 2 + (n / 2 - offset) * Math.sin(t);
		if (i == 0)
			plotter.move(x, y);
		else
			plotter.draw(x, y);
	}

private function loopE(plotter:PlotterE, n:Int, offset:Int)
	for (i in 0...5) {
		final t:Float = 2 * Math.PI * i / 5;
		final x:Float = n / 2 + (n / 2 - offset) * Math.cos(t);
		final y:Float = n / 2 + (n / 2 - offset) * Math.sin(t);
		if (i == 0)
			plotter.plot(Move(x, y));
		else
			plotter.plot(Draw(x, y));
	}
