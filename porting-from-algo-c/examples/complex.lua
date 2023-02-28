--
--	from src/complex.c
--
--	complex c_conv(double, double)		to	complexNumber, complexNumberS
--	char * c_string(complex)		to	__tostring
--
--	double c_abs(complex)			to	:abs(, cnAbs)
--	double c_arg(complex)			to	:arg(, cnArg)
--
--	complex c_conj(complex)			to	:conjugate / .conjugate
--	complex c_add(complex, complex)		to	__add, cnAdd / .add
--	complex c_sub(complex, complex)		to	__sub, cnSub / .sub
--	complex c_mul(complex, complex)		to	__mul, cnMul / .mul
--	complex c_div(complex, complex)		to	__div, cnDiv / .div
--	complex c_pow(complex, complex)		to	__pow, cnPow / .pow
--
--	complex c_exp(complex)			to	:exp, cnExp / .exp
--	complex c_log(complex)			to	:log, cnLog / .log
--	complex c_sqrt(complex)			to	:sqrt, cnSqrt / .sqrt
--
--	complex c_sin(complex)			to	:sin, cnSin / .sin
--	complex c_cos(complex)			to	:cos, cnCos / .cos
--	complex c_tan(complex)			to	:tan, cnTan / .tan
--	complex c_sinh(complex)			to	:sinh, cnSinh / .sinh
--	complex c_cosh(complex)			to	:cosh, cnCosh / .cosh
--	complex c_tanh(complex)			to	:tanh, cnTanh / .tanh
--
--							/ overloadWithInplaceMethods
--

local M = require 'complex'

local complexNumber = M.complexNumber
local complexNumberS = M.complexNumberS
local cnAdd = M.cnAdd
local cnSub = M.cnSub
local cnMul = M.cnMul
local cnDiv = M.cnDiv
local cnPow = M.cnPow
local cnExp = M.cnExp
local cnLog = M.cnLog
local cnSqrt = M.cnSqrt
local cnSin = M.cnSin
local cnCos = M.cnCos
local cnTan = M.cnTan
local cnSinh = M.cnSinh
local cnCosh = M.cnCosh
local cnTanh = M.cnTanh
local overloadWithInplaceMethods = M.overloadWithInplaceMethods
local cnAbs = M.cnAbs
local cnArg = M.cnArg

do
	local a, b = complexNumber(1, -2), complexNumber(-2, 3)
	local c, d = complexNumberS(1, -2), complexNumberS(-2, 3)

	assert(a == complexNumber(1, -2))
	assert(c == complexNumberS(1, -2))
	assert(a == c and b == d)

	assert(a:abs() == c:abs())
	assert(a:abs() == cnAbs(a))
	assert(a:arg() == c:arg())
	assert(a:arg() == cnArg(a))
	assert(a:conjugate():conjugate() == a)
	assert(a:conjugate() == c:conjugate())

	assert(a + b == cnAdd(c, d))
	assert(a - b == cnSub(c, d))
	assert(a * b == cnMul(c, d))
	assert(a / b == cnDiv(c, d))
	assert(a ^ b == cnPow(c, d))

	assert(a:exp() == cnExp(c))
	assert(a:log() == cnLog(c))
	assert(a:sqrt() == cnSqrt(c))

	assert(a:exp():log():exp() == cnExp(cnLog(cnExp(c))))
	assert(a:log():exp():log() == cnLog(cnExp(cnLog(c))))

	assert(a:sin() == cnSin(c))
	assert(a:cos() == cnCos(c))
	assert(a:tan() == cnTan(c))
	assert(a:sinh() == cnSinh(c))
	assert(a:cosh() == cnCosh(c))
	assert(a:tanh() == cnTanh(c))

	assert(a == c and b == d)
	local r, i = a:get()
	overloadWithInplaceMethods(a)
	overloadWithInplaceMethods(c)
	--
	local t = complexNumberS(r, i):conjugate()
	a.conjugate()
	c.conjugate()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = a + b
	a.add(b)
	c.add(d)
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = a - b
	a.sub(b)
	c.sub(d)
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = a * b
	a.mul(b)
	c.mul(d)
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = a / b
	a.div(b)
	c.div(d)
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = a ^ b
	a.pow(b)
	c.pow(d)
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnExp(a)
	a.exp()
	c.exp()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnLog(a)
	a.log()
	c.log()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnSqrt(a)
	a.sqrt()
	c.sqrt()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnSin(a)
	a.sin()
	c.sin()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnCos(a)
	a.cos()
	c.cos()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnTan(a)
	a.tan()
	c.tan()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnSinh(a)
	a.sinh()
	c.sinh()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnCosh(a)
	a.cosh()
	c.cosh()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	t = cnTanh(a)
	a.tanh()
	c.tanh()
	assert(t == a and t == c)
	--
	a:set(r, i)
	c:set(r, i)
	a.conjugate().conjugate()
	c.conjugate().conjugate()
	assert(complexNumber(r, i) == a)
	assert(complexNumber(r, i) == c)
	--
	a:set(r, i)
	c:set(r, i)
	a.log().exp()
	c.log().exp()
	assert(complexNumber(r, i):log():exp() == a)
	assert(complexNumber(r, i):log():exp() == c)
end

local deg = math.deg
function toPolarForm(c)
	return ("%gxCis(%g(rad)) (%g(deg))"):format(c:abs(), c:arg(), deg(c:arg()))
end

function getReciprocal(c, initialFunction)
	initialFunction = initialFunction ~= nil and initialFunction or complexNumber

	local r, i = c:get()
	if r == 0 and i == 0 then
		io.stderr:write("Error: can't get the reciprocal of 0+0i\n")
		return
	end

	local t = c:abs()
	return initialFunction(r / (t * t), -i / (t * t))
end

do
	local a, b = complexNumber(1, 1), complexNumber(-1, 1)
	local c, d = b:conjugate(), a:conjugate()

	print(("%5s : %s"):format(a, toPolarForm(a)))
	print(("%5s : %s"):format(b, toPolarForm(b)))
	print(("%5s : %s"):format(c, toPolarForm(c)))
	print(("%5s : %s"):format(d, toPolarForm(d)))

	local e, f = complexNumberS(1, 0), complexNumberS(23, 45)
	assert(e == f * getReciprocal(f))
	overloadWithInplaceMethods(f)
	assert(e == f.mul(getReciprocal(f)))
end
