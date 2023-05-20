//
//	from src/complex.c
//
//	struct complex				to	Complex
//	complex c_conv(double, double)		to	/ ComplexNumber
//	char * c_string(complex)		to	/ toString
//
//	double c_abs(complex)			to	abs / .abs
//	double c_arg(complex)			to	arg / .arg
//
//	complex c_conj(complex)			to	conjugate / .conjugate
//	complex c_add(complex, complex)		to	add / .add
//	complex c_sub(complex, complex)		to	sub / .sub
//	complex c_mul(complex, complex)		to	mul / .mul
//	complex c_div(complex, complex)		to	div / .div
//	complex c_pow(complex, complex)		to	pow / .pow
//
//	complex c_exp(complex)			to	exp / .exp
//	complex c_log(complex)			to	log / .log
//	complex c_sqrt(complex)			to	sqrt / .sqrt
//
//	complex c_sin(complex)			to	sin / .sin
//	complex c_cos(complex)			to	cos / .cos
//	complex c_tan(complex)			to	tan / .tan
//	complex c_sinh(complex)			to	sinh / .sinh
//	complex c_cosh(complex)			to	cosh / .cosh
//	complex c_tanh(complex)			to	tanh / .tanh
//

package src;

typedef Complex = {
	var r:Float;  // real
	var i:Float;  // imaginary
}

function abs(c:Complex):Float {
	return switch [c.r, c.i] {
		case [0, _]:
			Math.abs(c.i);
		case [_, 0]:
			Math.abs(c.r);
		case [r, i] if (r < i):
			var t = r / i;
			Math.abs(i) * Math.sqrt(1 + t * t);
		case [r, i]:
			var t = i / r;
			Math.abs(r) * Math.sqrt(1 + t * t);
	}
}

function arg(c:Complex):Float {
	return Math.atan2(c.i, c.r);
}

function conjugate(c:Complex):Complex {
	var a:Complex = { r: c.r, i: -c.i };
	return a;
}

function add(a:Complex, b:Complex):Complex {
	var c:Complex = { r: a.r + b.r, i: a.i + b.i };
	return c;
}

function sub(a:Complex, b:Complex):Complex {
	var c:Complex = { r: a.r - b.r, i: a.i - b.i };
	return c;
}

function mul(a:Complex, b:Complex):Complex {
	var c:Complex = {
		r: a.r * b.r - a.i * b.i,
		i: a.r * b.i + a.i * b.r
	};
	return c;
}

function div(a:Complex, b:Complex):Complex {
	var c:Complex = if (Math.abs(b.r) >= Math.abs(b.i)) {
		var w = b.i / b.r;
		var d = b.r + b.i * w;
		{ r: (a.r + a.i * w) / d, i: (a.i - a.r * w) / d };
	} else {
		var w = b.r / b.i;
		var d = b.r * w + b.i;
		{ r: (a.r * w + a.i) / d, i: (a.i * w - a.r) / d };
	}
	return c;
}

function pow(a:Complex, b:Complex):Complex {
	// log(a)
	var c:Complex = {
		r: 0.5 * Math.log(a.r * a.r + a.i * a.i),
		i: Math.atan2(a.i, a.r)
	};
	//  mul(b, log(a))
	c = {
		r: b.r * c.r - b.i * c.i,
		i: b.r * c.i + b.i * c.r
	};
	//  exp(mul(b, log(a)))
	c = {
		r: Math.exp(c.r) * Math.cos(c.i),
		i: Math.exp(c.r) * Math.sin(c.i)
	};
	return c;
}

function exp(c:Complex):Complex {
	var a:Complex = {
		r: Math.exp(c.r) * Math.cos(c.i),
		i: Math.exp(c.r) * Math.sin(c.i)
	};
	return a;
}

function log(c:Complex):Complex {
	var a:Complex = {
		r: 0.5 * Math.log(c.r * c.r + c.i * c.i),
		i: Math.atan2(c.i, c.r)
	};
	return a;
}

final SQRT05 = Math.sqrt(0.5);

function sqrt(c:Complex):Complex {
	var w = Math.sqrt(abs(c) + Math.abs(c.r));
	var a:Complex = if (c.r >= 0) {
		{
			r: SQRT05 * w,
			i: SQRT05 * c.i / w
		}
	} else {
		{
			r: SQRT05 * Math.abs(c.i) / w,
			i: (if (c.i >= 0) SQRT05 else -SQRT05) * w
		}
	}
	return a;
}

function sin(c:Complex):Complex {
	var e = Math.exp(c.i);
	var f = 1 / e;
	var a:Complex = {
		r: 0.5 * Math.sin(c.r) * (e + f),
		i: 0.5 * Math.cos(c.r) * (e - f)
	};
	return a;
}

function cos(c:Complex):Complex {
	var e = Math.exp(c.i);
	var f = 1 / e;
	var a:Complex = {
		r: 0.5 * Math.cos(c.r) * (f + e),
		i: 0.5 * Math.sin(c.r) * (f - e)
	};
	return a;
}

function tan(c:Complex):Complex {
	var e = Math.exp(2 * c.i);
	var f = 1 / e;
	var d = Math.cos(2 * c.r) + 0.5 * (e + f);
	var a:Complex = {
		r: Math.sin(2 * c.r) / d,
		i: 0.5 * (e - f) / d
	};
	return a;
}

function sinh(c:Complex):Complex {
	var e = Math.exp(c.r);
	var f = 1 / e;
	var a:Complex = {
		r: 0.5 * (e - f) * Math.cos(c.i),
		i: 0.5 * (e + f) * Math.sin(c.i)
	};
	return a;
}

function cosh(c:Complex):Complex {
	var e = Math.exp(c.r);
	var f = 1 / e;
	var a:Complex = {
		r: 0.5 * (e + f) * Math.cos(c.i),
		i: 0.5 * (e - f) * Math.sin(c.i)
	};
	return a;
}

function tanh(c:Complex):Complex {
	var e = Math.exp(2 * c.r);
	var f = 1 / e;
	var d = 0.5 * (e + f) + Math.cos(2 * c.i);
	var a:Complex = {
		r: 0.5 * (e - f) / d,
		i: Math.sin(2 * c.i) / d
	};
	return a;
}

//

class ComplexNumber {
	var c:Complex;

	public function new(a:Complex) {
		c = { r: a.r, i: a.i };
	}

	public function get():Complex {
		return c;
	}

	public function set(a:Complex) {
		c = { r: a.r, i: a.i };
	}

	public function toString():String {
		return c.r + (if (c.i < 0) "" else "+") + c.i + "i";
	}

	public function abs():Float {
		return switch [c.r, c.i] {
			case [0, _]:
				Math.abs(c.i);
			case [_, 0]:
				Math.abs(c.r);
			case [r, i] if (r < i):
				var t = r / i;
				Math.abs(i) * Math.sqrt(1 + t * t);
			case [r, i]:
				var t = i / r;
				Math.abs(r) * Math.sqrt(1 + t * t);
		}
	}

	public function arg():Float {
		return Math.atan2(c.i, c.r);
	}

	public function conjugate():ComplexNumber {
		c.i = -c.i;
		return this;
	}

	public function add(a:ComplexNumber):ComplexNumber {
		c = {
			r: c.r + a.c.r,
			i: c.i + a.c.i
		};
		return this;
	}

	public function sub(a:ComplexNumber):ComplexNumber {
		c = {
			r: c.r - a.c.r,
			i: c.i - a.c.i
		};
		return this;
	}

	public function mul(a:ComplexNumber):ComplexNumber {
		c = {
			r: c.r * a.c.r - c.i * a.c.i,
			i: c.r * a.c.i + c.i * a.c.r
		}
		return this;
	}

	public function div(a:ComplexNumber):ComplexNumber {
		c = if (Math.abs(a.c.r) >= Math.abs(a.c.i)) {
			var w = a.c.i / a.c.r;
			var d = a.c.r + a.c.i * w;
			{
				r: (c.r + c.i * w) / d,
				i: (c.i - c.r * w) / d
			};
		} else {
			var w = a.c.r / a.c.i;
			var d = a.c.r * w + a.c.i;
			{
				r: (c.r * w + c.i) / d,
				i: (c.i * w - c.r) / d
			};
		};
		return this;
	}

	public function pow(a:ComplexNumber):ComplexNumber {
		// log(c)
		var t:Complex = {
			r: 0.5 * Math.log(c.r * c.r + c.i * c.i),
			i: Math.atan2(c.i, c.r)
		};
		// mul(a, log(c))
		t = {
			r: a.c.r * t.r - a.c.i * t.i,
			i: a.c.r * t.i + a.c.i * t.r
		};
		// exp(mul(a, log(c)))
		c = {
			r: Math.exp(t.r) * Math.cos(t.i),
			i: Math.exp(t.r) * Math.sin(t.i)
		};
		return this;
	}

	public function exp():ComplexNumber {
		c = {
			r: Math.exp(c.r) * Math.cos(c.i),
			i: Math.exp(c.r) * Math.sin(c.i)
		};
		return this;
	}

	public function log():ComplexNumber {
		c = {
			r: 0.5 * Math.log(c.r * c.r + c.i * c.i),
			i: Math.atan2(c.i, c.r)
		};
		return this;
	}

	public function sqrt():ComplexNumber {
		var w = Math.sqrt(abs() + Math.abs(c.r));
		c = if (c.r >= 0) {
			{
				r: SQRT05 * w,
				i: SQRT05 * c.i / w
			}
		} else {
			{
				r: SQRT05 * Math.abs(c.i) / w,
				i: (if (c.i >= 0) SQRT05 else -SQRT05) * w
			}
		};
		return this;
	}

	public function sin():ComplexNumber {
		var e = Math.exp(c.i);
		var f = 1 / e;
		c = {
			r: 0.5 * Math.sin(c.r) * (e + f),
			i: 0.5 * Math.cos(c.r) * (e - f)
		};
		return this;
	}

	public function cos():ComplexNumber {
		var e = Math.exp(c.i);
		var f = 1 / e;
		c = {
			r: 0.5 * Math.cos(c.r) * (f + e),
			i: 0.5 * Math.sin(c.r) * (f - e)
		};
		return this;
	}

	public function tan():ComplexNumber {
		var e = Math.exp(2 * c.i);
		var f = 1 / e;
		var d = Math.cos(2 * c.r) + 0.5 * (e + f);
		c = {
			r: Math.sin(2 * c.r) / d,
			i: 0.5 * (e - f) / d
		};
		return this;
	}

	public function sinh():ComplexNumber {
		var e = Math.exp(c.r);
		var f = 1 / e;
		c = {
			r: 0.5 * (e - f) * Math.cos(c.i),
			i: 0.5 * (e + f) * Math.sin(c.i)
		};
		return this;
	}

	public function cosh():ComplexNumber {
		var e = Math.exp(c.r);
		var f = 1 / e;
		c = {
			r: 0.5 * (e + f) * Math.cos(c.i),
			i: 0.5 * (e - f) * Math.sin(c.i)
		};
		return this;
	}

	public function tanh():ComplexNumber {
		var e = Math.exp(2 * c.r);
		var f = 1 / e;
		var d = 0.5 * (e + f) + Math.cos(2 * c.i);
		c = {
			r: 0.5 * (e - f) / d,
			i: Math.sin(2 * c.i) / d
		};
		return this;
	}
}

//

function demo() {
	var a:Complex = { r: 1, i: -2 };
	var b:Complex = { r: -2, i: 3 };
	var c = new ComplexNumber(a);
	var d = new ComplexNumber(b);

	trace('c: $c, a: $a');
	trace('d: $d, b: $b');

	trace("--");

	trace('c.abs(): ${c.abs()}, abs(a): ${abs(a)}');
	trace('c.arg(): ${c.arg()}, arg(a): ${arg(a)}');

	trace("--");

	trace('c.conjugate(): ${c.conjugate()}, conjugate(a): ${conjugate(a)}');
	c.set(a);
	trace('c.add(d): ${c.add(d)}, add(a, b): ${add(a, b)}');
	c.set(a);
	trace('c.sub(d): ${c.sub(d)}, sub(a, b): ${sub(a, b)}');
	c.set(a);
	trace('c.mul(d): ${c.mul(d)}, mul(a, b): ${mul(a, b)}');
	c.set(a);
	trace('c.div(d): ${c.div(d)}, div(a, b): ${div(a, b)}');
	c.set(a);
	trace('c.pow(d): ${c.pow(d)}, pow(a, b): ${pow(a, b)}');

	trace("--");

	c.set(a);
	trace('c.exp(): ${c.exp()}, exp(a): ${exp(a)}');
	c.set(a);
	trace('c.log(): ${c.log()}, log(a): ${log(a)}');
	c.set(a);
	trace('c.exp().log(): ${c.exp().log()}, log(exp(a)): ${log(exp(a))}');
	c.set(a);
	trace('c.log().exp(): ${c.log().exp()}, exp(log(a)): ${exp(log(a))}');
	c.set(a);
	trace('c.sqrt(): ${c.sqrt()}, sqrt(a): ${sqrt(a)}');

	trace("--");

	c.set(a);
	trace('c.sin(): ${c.sin()}, sin(a): ${sin(a)}');
	c.set(a);
	trace('c.cos(): ${c.cos()}, cos(a): ${cos(a)}');
	c.set(a);
	trace('c.tan(): ${c.tan()}, tan(a): ${tan(a)}');
	c.set(a);
	trace('c.sinh(): ${c.sinh()}, sinh(a): ${sinh(a)}');
	c.set(a);
	trace('c.cosh(): ${c.cosh()}, cosh(a): ${cosh(a)}');
	c.set(a);
	trace('c.tanh(): ${c.tanh()}, tanh(a): ${tanh(a)}');
}
