//
//	Hello, World! in Haxe
//
//	with something like GNU dc's P command:
//	$ dc -e "1468369091346906859060166438166794P"
//	(see https://github.com/826814741-6/aRepo/blob/main/misc/hi.sh)
//
//	depends on littleBigInt; https://github.com/maitag/littleBigInt
//

//
//	in interpreter (Eval target):
//	$ haxe -L littleBigInt --interp --main Hi
//
//	in HashLink:
//	$ haxe -L littleBigInt --hl hi.hl --main Hi
//	$ hl hi.hl
//
//	in HashLink/C:
//	$ haxe -L littleBigInt --hl out/main.c --main Hi
//	$ gcc -Iout out/main.c -lhl -o hi [...some options...]
//	$ ./hi
//
//	(in JVM: (*)
//	$ haxe -L littleBigInt --jvm hi.jar --main Hi
//	$ java -jar hi.jar
//
//	  *) As of 18th Jan 2023,
//	     littleBigInt doesn't announce the support for JVM target.)
//
//	(see: https://haxe.org/manual/compiler-usage.html#common-arguments)
//

using Sys;

private function recA(n:BigInt, a:Array<String>):Array<String>
	return if (n > 255) {
		a.insert(0, String.fromCharCode(n % 256));
		recA(n / 256, a);
	} else {
		a.insert(0, String.fromCharCode(n));
		a;
	}

private function recL(n:BigInt, l:List<String>):List<String>
	return if (n > 255) {
		l.push(String.fromCharCode(n % 256));
		recL(n / 256, l);
	} else {
		l.push(String.fromCharCode(n));
		l;
	}

function PwithArray(n:BigInt)
	recA(n, new Array<String>())
		.join("")
		.print();

function PwithList(n:BigInt)
	recL(n, new List<String>())
		.join("")
		.print();

// and some utils

function strToSrc(s:String):BigInt {
	var r:BigInt = 0;
	var i:Int = s.length - 1;
	var e:Int = 0;
	final b:BigInt = 256;

	while (i >= 0) {
		r += StringTools.fastCodeAt(s, i) * b.pow(e);
		e += 1;
		i -= 1;
	}

	return r;
}

//

function main() {
	final m:BigInt = "1468369091346906859060166438166794";

	PwithArray(m);
	PwithList(m);

	strToSrc("Hello, World!\n")
		.toString()
		.println();
}
