//
//	from src/complex.c
//
//	struct complex				to	Complex
//	complex c_conv(double, double)		to	/ ComplexNumber
//	char * c_string(complex)		to	/ toString
//
//	double c_abs(complex)			to	cAbs / .abs
//	double c_arg(complex)			to	cArg / .arg
//
//	complex c_conj(complex)			to	cConjugate / .conjugate
//	complex c_add(complex, complex)		to	cAdd / .add
//	complex c_sub(complex, complex)		to	cSub / .sub
//	complex c_mul(complex, complex)		to	cMul / .mul
//	complex c_div(complex, complex)		to	cDiv / .div
//	complex c_pow(complex, complex)		to	cPow / .pow
//
//	complex c_exp(complex)			to	cExp / .exp
//	complex c_log(complex)			to	cLog / .log
//	complex c_sqrt(complex)			to	cSqrt / .sqrt
//
//	complex c_sin(complex)			to	cSin / .sin
//	complex c_cos(complex)			to	cCos / .cos
//	complex c_tan(complex)			to	cTan / .tan
//	complex c_sinh(complex)			to	cSinh / .sinh
//	complex c_cosh(complex)			to	cCosh / .cosh
//	complex c_tanh(complex)			to	cTanh / .tanh
//
//							(return-new-one / in-place)
//

package src;

typedef Complex = {
	var r:Float;  // real
	var i:Float;  // imaginary
}

function cAbs(c:Complex):Float
	return switch [c.r, c.i] {
		case [0, _]:
			Math.abs(c.i);
		case [_, 0]:
			Math.abs(c.r);
		case [r, i] if (r < i):
			final t = r / i;
			Math.abs(i) * Math.sqrt(1 + t * t);
		case [r, i]:
			final t = i / r;
			Math.abs(r) * Math.sqrt(1 + t * t);
	}

function cArg(c:Complex):Float
	return Math.atan2(c.i, c.r);

function cConjugate(c:Complex):Complex
	return { r: c.r, i: -c.i };

function cAdd(a:Complex, b:Complex):Complex
	return { r: a.r + b.r, i: a.i + b.i };

function cSub(a:Complex, b:Complex):Complex
	return { r: a.r - b.r, i: a.i - b.i };

function cMul(a:Complex, b:Complex):Complex
	return {
		r: a.r * b.r - a.i * b.i,
		i: a.r * b.i + a.i * b.r
	};

function cDiv(a:Complex, b:Complex):Complex
	return if (Math.abs(b.r) >= Math.abs(b.i)) {
		final w = b.i / b.r;
		final d = b.r + b.i * w;
		{ r: (a.r + a.i * w) / d, i: (a.i - a.r * w) / d };
	} else {
		final w = b.r / b.i;
		final d = b.r * w + b.i;
		{ r: (a.r * w + a.i) / d, i: (a.i * w - a.r) / d };
	};

function cPow(a:Complex, b:Complex):Complex
	return cExp(cMul(b, cLog(a))); // exp(mul(a, log(c)))

function cExp(c:Complex):Complex
	return {
		r: Math.exp(c.r) * Math.cos(c.i),
		i: Math.exp(c.r) * Math.sin(c.i)
	};

function cLog(c:Complex):Complex
	return {
		r: 0.5 * Math.log(c.r * c.r + c.i * c.i),
		i: Math.atan2(c.i, c.r)
	};

final SQRT05 = Math.sqrt(0.5);

function cSqrt(c:Complex):Complex {
	final w = Math.sqrt(cAbs(c) + Math.abs(c.r));
	return if (c.r >= 0) {
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
}

function cSin(c:Complex):Complex {
	final e = Math.exp(c.i);
	return {
		r: 0.5 * Math.sin(c.r) * (e + 1 / e),
		i: 0.5 * Math.cos(c.r) * (e - 1 / e)
	};
}

function cCos(c:Complex):Complex {
	final e = Math.exp(c.i);
	return {
		r: 0.5 * Math.cos(c.r) * (1 / e + e),
		i: 0.5 * Math.sin(c.r) * (1 / e - e)
	};
}

function cTan(c:Complex):Complex {
	final e = Math.exp(2 * c.i);
	final d = Math.cos(2 * c.r) + 0.5 * (e + 1 / e);
	return {
		r: Math.sin(2 * c.r) / d,
		i: 0.5 * (e - 1 / e) / d
	};
}

function cSinh(c:Complex):Complex {
	final e = Math.exp(c.r);
	return {
		r: 0.5 * (e - 1 / e) * Math.cos(c.i),
		i: 0.5 * (e + 1 / e) * Math.sin(c.i)
	};
}

function cCosh(c:Complex):Complex {
	final e = Math.exp(c.r);
	return {
		r: 0.5 * (e + 1 / e) * Math.cos(c.i),
		i: 0.5 * (e - 1 / e) * Math.sin(c.i)
	};
}

function cTanh(c:Complex):Complex {
	final e = Math.exp(2 * c.r);
	final d = 0.5 * (e + 1 / e) + Math.cos(2 * c.i);
	return {
		r: 0.5 * (e - 1 / e) / d,
		i: Math.sin(2 * c.i) / d
	};
}

//

class ComplexNumber {
	final c:Complex;

	public function new(a:Complex)
		c = { r: a.r, i: a.i };

	public function get():Complex
		return c;

	public function set(a:Complex) {
		c.r = a.r;
		c.i = a.i;
	}

	public function toString():String
		return c.r + (if (c.i < 0) "" else "+") + c.i + "i";

	public function abs():Float
		return cAbs(c);

	public function arg():Float
		return cArg(c);

	public function conjugate():ComplexNumber {
		c.i = -c.i;
		return this;
	}

	public function add(a:Complex):ComplexNumber {
		c.r = c.r + a.r;
		c.i = c.i + a.i;
		return this;
	}

	public function sub(a:Complex):ComplexNumber {
		c.r = c.r - a.r;
		c.i = c.i - a.i;
		return this;
	}

	public function mul(a:Complex):ComplexNumber {
		final t = { r: c.r, i: c.i };
		c.r = t.r * a.r - t.i * a.i;
		c.i = t.r * a.i + t.i * a.r;
		return this;
	}

	public function div(a:Complex):ComplexNumber {
		final t = { r: c.r, i: c.i };
		if (Math.abs(a.r) >= Math.abs(a.i)) {
			final w = a.i / a.r;
			final d = a.r + a.i * w;
			c.r = (t.r + t.i * w) / d;
			c.i = (t.i - t.r * w) / d;
		} else {
			final w = a.r / a.i;
			final d = a.r * w + a.i;
			c.r = (t.r * w + t.i) / d;
			c.i = (t.i * w - t.r) / d;
		}
		return this;
	}

	public function pow(a:Complex):ComplexNumber {
		log().mul(a).exp(); // exp(mul(a, log(c)))
		return this;
	}

	public function exp():ComplexNumber {
		final t = { r: c.r, i: c.i };
		c.r = Math.exp(t.r) * Math.cos(t.i);
		c.i = Math.exp(t.r) * Math.sin(t.i);
		return this;
	}

	public function log():ComplexNumber {
		final t = { r: c.r, i: c.i };
		c.r = 0.5 * Math.log(t.r * t.r + t.i * t.i);
		c.i = Math.atan2(t.i, t.r);
		return this;
	}

	public function sqrt():ComplexNumber {
		final t = c.i;
		final w = Math.sqrt(abs() + Math.abs(c.r));
		if (c.r >= 0) {
			c.r = SQRT05 * w;
			c.i = SQRT05 * t / w;
		} else {
			c.r = SQRT05 * Math.abs(t) / w;
			c.i = (if (t >= 0) SQRT05 else -SQRT05) * w;
		}
		return this;
	}

	public function sin():ComplexNumber {
		final t = c.r;
		final e = Math.exp(c.i);
		c.r = 0.5 * Math.sin(t) * (e + 1 / e);
		c.i = 0.5 * Math.cos(t) * (e - 1 / e);
		return this;
	}

	public function cos():ComplexNumber {
		final t = c.r;
		final e = Math.exp(c.i);
		c.r = 0.5 * Math.cos(t) * (1 / e + e);
		c.i = 0.5 * Math.sin(t) * (1 / e - e);
		return this;
	}

	public function tan():ComplexNumber {
		final t = c.r;
		final e = Math.exp(2 * c.i);
		final d = Math.cos(2 * t) + 0.5 * (e + 1 / e);
		c.r = Math.sin(2 * t) / d;
		c.i = 0.5 * (e - 1 / e) / d;
		return this;
	}

	public function sinh():ComplexNumber {
		final t = c.i;
		final e = Math.exp(c.r);
		c.r = 0.5 * (e - 1 / e) * Math.cos(t);
		c.i = 0.5 * (e + 1 / e) * Math.sin(t);
		return this;
	}

	public function cosh():ComplexNumber {
		final t = c.i;
		final e = Math.exp(c.r);
		c.r = 0.5 * (e + 1 / e) * Math.cos(t);
		c.i = 0.5 * (e - 1 / e) * Math.sin(t);
		return this;
	}

	public function tanh():ComplexNumber {
		final t = c.i;
		final e = Math.exp(2 * c.r);
		final d = 0.5 * (e + 1 / e) + Math.cos(2 * t);
		c.r = 0.5 * (e - 1 / e) / d;
		c.i = Math.sin(2 * t) / d;
		return this;
	}
}

//

function demo() {
	final a:Complex = { r: 1, i: -2 };
	final b:Complex = { r: -2, i: 3 };
	final c = new ComplexNumber(a);

	trace('c: $c, a: $a, b : $b');

	trace("--");

	trace('c.abs(): ${c.abs()}, cAbs(a): ${cAbs(a)}');
	trace('c.arg(): ${c.arg()}, cArg(a): ${cArg(a)}');

	trace("--");

	trace('c.conjugate(): ${c.conjugate()}, cConjugate(a): ${cConjugate(a)}');
	c.set(a);
	trace('c.add(b): ${c.add(b)}, cAdd(a, b): ${cAdd(a, b)}');
	c.set(a);
	trace('c.sub(b): ${c.sub(b)}, cSub(a, b): ${cSub(a, b)}');
	c.set(a);
	trace('c.mul(b): ${c.mul(b)}, cMul(a, b): ${cMul(a, b)}');
	c.set(a);
	trace('c.div(b): ${c.div(b)}, cDiv(a, b): ${cDiv(a, b)}');
	c.set(a);
	trace('c.pow(b): ${c.pow(b)}, cPow(a, b): ${cPow(a, b)}');

	trace("--");

	c.set(a);
	trace('c.exp(): ${c.exp()}, cExp(a): ${cExp(a)}');
	c.set(a);
	trace('c.log(): ${c.log()}, cLog(a): ${cLog(a)}');
	c.set(a);
	trace('c.exp().log(): ${c.exp().log()}, cLog(cExp(a)): ${cLog(cExp(a))}');
	c.set(a);
	trace('c.log().exp(): ${c.log().exp()}, cExp(cLog(a)): ${cExp(cLog(a))}');
	c.set(a);
	trace('c.sqrt(): ${c.sqrt()}, cSqrt(a): ${cSqrt(a)}');

	trace("--");

	c.set(a);
	trace('c.sin(): ${c.sin()}, cSin(a): ${cSin(a)}');
	c.set(a);
	trace('c.cos(): ${c.cos()}, cCos(a): ${cCos(a)}');
	c.set(a);
	trace('c.tan(): ${c.tan()}, cTan(a): ${cTan(a)}');
	c.set(a);
	trace('c.sinh(): ${c.sinh()}, cSinh(a): ${cSinh(a)}');
	c.set(a);
	trace('c.cosh(): ${c.cosh()}, cCosh(a): ${cCosh(a)}');
	c.set(a);
	trace('c.tanh(): ${c.tanh()}, cTanh(a): ${cTanh(a)}');
}
