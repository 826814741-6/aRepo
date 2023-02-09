package src;

function with(path:String, binary:Bool=true, aFunc:sys.io.FileOutput->Void) {
	var fh = sys.io.File.write(path, binary);
	aFunc(fh);
	fh.close();
}
