//
//	Hello, World! in Haxe
//
//	with something like GNU dc's P command:
//	$ dc -e "1468369091346906859060166438166794P"
//	(see https://github.com/nobi56/aRepo/blob/master/misc/hi.sh)
//
//	depends on littleBigInt; https://github.com/maitag/littleBigInt
//

//
//	in HashLink:
//	$ haxe -lib littleBigInt --hl hi.hl --main Hi
//	$ hl hi.hl
//
//	in HashLink/C:
//	$ haxe -lib littleBigInt --hl out/main.c --main Hi
//	$ gcc -Iout out/main.c -lhl -o hi [-O3 ...]
//	$ ./hi
//

function f(n:BigInt, a:Array<String>):Array<String> {
	if (n > 255) {
		a.insert(0, String.fromCharCode(n % 256));
		return f(n / 256, a);
	} else {
		a.insert(0, String.fromCharCode(n));
		return a;
	}
}

function P(n:BigInt) {
	var a = new Array<String>();
	Sys.print(f(n, a).join(""));
}

// and some utils

function strToSrc(s:String):BigInt {
	var r:BigInt = 0;
	var i:Int = s.length-1;
	var b:BigInt = 256;
	var e:Int = 0;

	while (i >= 0) {
		r += StringTools.fastCodeAt(s, i) * b.pow(e);
		e += 1;
		i -= 1;
	}

	return r;
}

//

function main() {
	var m:BigInt = "1468369091346906859060166438166794";
	P(m);

	var s = "Hello, World!\n";
	Sys.println(strToSrc(s).toString());
}
