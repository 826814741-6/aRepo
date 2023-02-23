//
//	from src/egypfrac.c
//
//	a part of main		to	EFIterator
//

package src;

class EFIterator {
	var n:Int;
	var d:Int;
	var state:Bool;

	public function new(numerator, denominator) {
		this.n = numerator;
		this.d = denominator;
		this.state = true;
	}

	public function hasNext():Bool {
		return this.state;
	}

	public function next() {
		if (this.d % this.n != 0) {
			var t = Math.floor(this.d / this.n) + 1;
			this.n = n * t - d;
			this.d = d * t;
			return '1/$t + ';
		} else {
			this.state = false;
			return '1/${Math.floor(this.d / this.n)}';
		}
	}
}

//

private function run(n:Int, d:Int) {
	var it = new EFIterator(n, d);

	Sys.print('$n/$d = ');
	for (e in it)
		Sys.print(e);
	Sys.println("");
}

function demo() {
	Sys.println("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...");

	Sys.print("e.g. ");
	var n:Int = 2;
	var d:Int = 5;
	run(n, d);

	Sys.print("e.g. ");
	n = 3;
	d = 5;
	run(n, d);

	Sys.print("numerator is > ");
	n = Std.parseInt(Sys.stdin().readLine());
	Sys.print("denominator is > ");
	d = Std.parseInt(Sys.stdin().readLine());
	run(n, d);

	//
	// Note:
	// In some(most?) cases, EFIterator is fragile.
	//
	// numerator is > 10
	// denominator is > 122
	// 10/122 = 1/13 + 1/199 + 1/52603 + 1/-144406485 + 1/-794368441
	//
}
