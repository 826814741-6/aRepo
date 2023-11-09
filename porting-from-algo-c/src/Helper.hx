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
	var n = length - Std.string(src).length;
	buf.add(src);
	for (_ in 0...n)
		buf.addChar(32);
}

@:generic
function rightAlignWithSpace<T>(buf:StringBuf, length:Int, src:T) {
	var n = length - Std.string(src).length;
	for (_ in 0...n)
		buf.addChar(32);
	buf.add(src);
}
