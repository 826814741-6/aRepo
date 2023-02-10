package src;

import sys.io.File;
import sys.io.FileOutput;

function withFileWrite(path:String, binary:Bool=true, aFunc:FileOutput->Void) {
	try {
		var fh = File.write(path, binary);
		aFunc(fh);
		fh.close();
	} catch(e) {
		trace(e.message);
	}
}
