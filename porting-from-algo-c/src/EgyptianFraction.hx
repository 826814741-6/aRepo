//
//	from src/egypfrac.c
//
//	a part of main		to	EFIterator
//

package src;

typedef Fraction = {
	var n:Int;  // numerator
	var d:Int;  // denominator
}

class EFIterator {
	var f:Fraction;
	var state:Bool;

	public function new(fraction) {
		f = { n: fraction.n, d: fraction.d };
		state = true;
	}

	public function hasNext():Bool {
		return state;
	}

	public function next():String {
		return if (f.d % f.n != 0) {
			var t = Math.floor(f.d / f.n) + 1;
			f = { n: f.n * t - f.d, d: f.d * t };
			'1/$t + ';
		} else {
			state = false;
			'1/${Math.floor(f.d / f.n)}';
		}
	}
}

//

private function run(f:Fraction) {
	var it = new EFIterator(f);

	Sys.print('${f.n}/${f.d} = ');
	for (e in it)
		Sys.print(e);
	Sys.println("");
}

function demo() {
	Sys.println("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...");

	Sys.print("e.g. ");
	var f:Fraction = { n: 2, d: 5 };
	run(f);

	Sys.print("e.g. ");
	f = { n: 3, d: 5 };
	run(f);

	Sys.print("numerator is > ");
	f.n = Std.parseInt(Sys.stdin().readLine());
	Sys.print("denominator is > ");
	f.d = Std.parseInt(Sys.stdin().readLine());
	run(f);

	//
	// Note:
	// In some(most?) cases, EFIterator is fragile.
	//
	// numerator is > 10
	// denominator is > 122
	// 10/122 = 1/13 + 1/199 + 1/52603 + 1/-144406485 + 1/-794368441
	//
}
