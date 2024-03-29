package src;

class PathStringExtender {
	static public function fileWrite(
		path:String,
		binary:Bool = true,
		aFunc:sys.io.FileOutput->Void
	) {
		try {
			var fh = sys.io.File.write(path, binary);
			aFunc(fh);
			fh.close();
		} catch(e) {
			trace(e.message);
		}
	}
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
