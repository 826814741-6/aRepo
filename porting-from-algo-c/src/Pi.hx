//
//	from src/pi1.c
//
//	long double pi(void)	to	machinLike
//
//	from src/pi2.c
//
//	a part of main		to	gaussLegendre
//

package src;

function machinLike():Float {
	var p:Float = 0;
	var k:Float = 1;
	var t:Float = 16 / 5;
	var prev:Float;

	do {
		prev = p;
		p += t / k;
		k += 2;
		t /= -5 * 5;
	} while (p != prev);

	k = 1;
	t = 4 / 239;

	do {
		prev = p;
		p -= t / k;
		k += 2;
		t /= -239 * 239;
	} while (p != prev);

	return p;
}

function gaussLegendre(n:Int):Float {
	var a:Float = 1;
	var b:Float = 1 / Math.sqrt(2);
	var t:Float = 1;
	var u:Float = 4;

	for (i in 0...n) {
		var prev:Float = a;
		a = (a + b) / 2;
		b = Math.sqrt(prev * b);
		t -= u * (a - prev) * (a - prev);
		u *= 2;
	}

	return (a + b) * (a + b) / t;
}

function demo() {
	trace("-------- machinLike:");
	trace(machinLike());
	trace("-------- gaussLegendre n:");
	trace(gaussLegendre(1));
	trace(gaussLegendre(2));
	trace(gaussLegendre(3));
	trace(gaussLegendre(4));
}
