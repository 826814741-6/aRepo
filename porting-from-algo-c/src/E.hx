//
//	from src/e.c
//
//	long double ee(void)	to	e
//

package src;

function e():Float {
	var r:Float = 0;
	var a:Float = 1;
	var n:Float = 1;
	var prev:Float;

	do {
		prev = r;
		r += a;
		a /= n;
		n += 1;
	} while (r != prev);

	return r;
}

function demo() {
	trace(e());
}
