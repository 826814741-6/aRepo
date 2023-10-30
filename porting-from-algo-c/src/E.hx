//
//	from src/e.c
//
//	long double ee(void)	to	e
//

package src;

typedef Result = {
	var value : Float;
	var count : Int;
}

function e():Result {
	var r:Float = 0;
	var a:Float = 1;
	var n:Int = 1;
	var prev:Float;

	do {
		prev = r;
		r += a;
		a /= n;
		n += 1;
	} while (r != prev);

	return { value: r, count: n - 1 };
}

function demo() {
	var e = e();
	trace(e.value, e.count);
}
