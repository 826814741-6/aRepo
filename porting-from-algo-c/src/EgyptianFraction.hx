//
//	from src/egypfrac.c
//
//	a part of main		to	EFIterator
//	EFIterator		to	EFIteratorM (*)
//
//	*) depends on littleBigInt
//	https://github.com/maitag/littleBigInt
//

package src;

@:generic
private abstract class EFIBase<T> {
	var n:T;
	var d:T;
	var state:Bool = true;

	public function new(numerator:T, denominator:T) {
		n = numerator;
		d = denominator;
	}

	public function hasNext():Bool
		return state;

	abstract public function next():String;
}

class EFIterator extends EFIBase<Int> {
	public function next():String
		return if (d % n != 0) {
			final t = Math.floor(d / n) + 1;
			n = n * t - d;
			d = d * t;
			'1/$t + ';
		} else {
			state = false;
			'1/${Math.floor(d / n)}';
		}
}

#if hasLittleBigInt
class EFIteratorM extends EFIBase<BigInt> {
	public function next():String
		return if (d % n != 0) {
			final t = d / n + 1;
			n = n * t - d;
			d = d * t;
			'1/$t + ';
		} else {
			state = false;
			'1/${d / n}';
		}
}
#end

//

private function run(n:Int, d:Int) {
	#if hasLittleBigInt
	final it = new EFIteratorM(n, d);
	#else
	final it = new EFIterator(n, d);
	#end

	Sys.print('${n}/${d} = ');
	for (e in it)
		Sys.print(e);
	Sys.println("");
}

function demo() {
	Sys.println("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...");

	Sys.print("e.g. ");
	run(2, 5);

	Sys.print("e.g. ");
	run(3, 5);

	Sys.print("numerator is > ");
	var n = Std.parseInt(Sys.stdin().readLine());
	Sys.print("denominator is > ");
	var d = Std.parseInt(Sys.stdin().readLine());
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
