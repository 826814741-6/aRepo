package src;

using src.SvgPlot;

class PathStringExtender {
	public static function fileWrite(
		path:String,
		binary:Bool = true,
		aFunc:sys.io.FileOutput->Void
	)
		try {
			final fh = sys.io.File.write(path, binary);
			aFunc(fh);
			fh.close();
		} catch(e) {
			trace(e.message);
		}

	public static function withSvgPlot(
		path:String,
		w:Int,
		h:Int,
		aFunc:SvgPlot -> Void
	)
		fileWrite(path, (fh) -> {
			final plotter = new SvgPlot(w, h);
			plotter.plotStart(fh);
			aFunc(plotter);
			plotter.plotEnd();
		});

	public static function withSvgPlotE(
		path:String,
		w:Int,
		h:Int,
		aFunc:SvgPlotE -> Void
	)
		fileWrite(path, (fh) -> {
			final plotter = new SvgPlotE(w, h);
			plotter.plotStart(fh);
			aFunc(plotter);
			plotter.plotEnd();
		});

	public static function withSvgPlotWithBuffer(
		path:String,
		w:Int,
		h:Int,
		limit:Int,
		aFunc:SvgPlotWithBuffer -> Void
	)
		fileWrite(path, (fh) -> {
			final plotter = new SvgPlotWithBuffer(w, h);
			plotter.plotStart(fh, limit);
			aFunc(plotter);
			plotter.plotEnd();
		});

	public static function withSvgPlotWithBufferE(
		path:String,
		w:Int,
		h:Int,
		limit:Int,
		aFunc:SvgPlotWithBufferE -> Void
	)
		fileWrite(path, (fh) -> {
			final plotter = new SvgPlotWithBufferE(w, h);
			plotter.plotStart(fh, limit);
			aFunc(plotter);
			plotter.plotEnd();
		});
}

@:generic
function leftAlignWithSpace<T>(buf:StringBuf, length:Int, src:T) {
	final n = length - Std.string(src).length;
	buf.add(src);
	buf.add(StringTools.rpad("", " ", n));
}

@:generic
function rightAlignWithSpace<T>(buf:StringBuf, length:Int, src:T) {
	final n = length - Std.string(src).length;
	buf.add(StringTools.rpad("", " ", n));
	buf.add(src);
}

private function gRandomUnsignedInteger(i:UInt):() -> UInt
	return () -> Math.floor(Math.random() * i);

final rndUInt8 = gRandomUnsignedInteger(0xff);
final rndUInt16 = gRandomUnsignedInteger(0xffff);
final rndUInt24 = gRandomUnsignedInteger(0xffffff);
final rndUInt32 = gRandomUnsignedInteger(0xffffffff);
