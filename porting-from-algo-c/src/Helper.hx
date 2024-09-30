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

	public static function withPlt(path:String, plotter:SvgPlot)
		return (aFunc:SvgPlot -> Void) ->
			fileWrite(path, (fh) -> {
				plotter.plotStart(fh);
				aFunc(plotter);
				plotter.plotEnd();
			});

	public static function withPltE(path:String, plotter:SvgPlotE)
		return (aFunc:SvgPlotE -> Void) ->
			fileWrite(path, (fh) -> {
				plotter.plotStart(fh);
				aFunc(plotter);
				plotter.plotEnd();
			});

	public static function withPltWB(
		path:String,
		plotter:SvgPlotWithBuffer,
		i:Int
	)
		return (aFunc:SvgPlotWithBuffer -> Void) ->
			fileWrite(path, (fh) -> {
				plotter.plotStart(fh, i);
				aFunc(plotter);
				plotter.plotEnd();
			});

	public static function withPltWBE(
		path:String,
		plotter:SvgPlotWithBufferE,
		i:Int
	)
		return (aFunc:SvgPlotWithBufferE -> Void) ->
			fileWrite(path, (fh) -> {
				plotter.plotStart(fh, i);
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
