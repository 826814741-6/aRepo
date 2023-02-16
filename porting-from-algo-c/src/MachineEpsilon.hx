//
//	from src/maceps.c
//
//	a part of main		to	MEIterator
//

package src;

class MEIterator {
	var e:Float;

	public function new() {
		this.e = 1;
	}

	public function hasNext():Bool {
		return 1 + this.e > 1;
	}

	public function next():Float {
		var prev = this.e;
		this.e /= 2;
		return prev;
	}
}

//

private function fmt(e:Float):String {
	var buf = new StringBuf();

	var g = (m, n) -> m - Std.string(n).length;
	var f = (m, n) -> {
		buf.add(n);
		for (_ in 0...g(m, n))
			buf.addChar(32);  // " "
	};

	f(25, e);
	f(21, 1 + e);
	f(23, (1 + e) - 1);

	return buf.toString();
}

function demo() {
	final FLT_EPSILON = 1.19209290e-07;          // from src/float.ie3
	final DBL_EPSILON = 2.2204460492503131e-16;  // from src/float.ie3

	trace(" e                        1 + e                (1 + e) - 1");
	trace("------------------------ -------------------- -----------------------");

	var it = new MEIterator();

	for (e in it) {
		trace(fmt(e));
		if (e - FLT_EPSILON <= DBL_EPSILON)
			break;
	}

	trace("^------- FLT_EPSILON");

	for (e in it) {
		trace(fmt(e));
	}
}
