--
--	from src/complex.c
--
--	complex c_conv(double, double)		to	complexNumber
--							/ complexNumberWithInplaceMethod
--	char * c_string(complex)		to	__tostring
--
--	double c_abs(complex)			to	:abs(, cnAbs)
--	double c_arg(complex)			to	:arg(, cnArg)
--
--	complex c_conj(complex)			to	cnConjugate / :conjugate
--	complex c_add(complex, complex)		to	__add, cnAdd / :add
--	complex c_sub(complex, complex)		to	__sub, cnSub / :sub
--	complex c_mul(complex, complex)		to	__mul, cnMul / :mul
--	complex c_div(complex, complex)		to	__div, cnDiv / :div
--	complex c_pow(complex, complex)		to	__pow, cnPow / :pow
--
--							overloadOperator /
--
--	complex c_exp(complex)			to	cnExp / :exp
--	complex c_log(complex)			to	cnLog / :log
--	complex c_sqrt(complex)			to	cnSqrt / :sqrt
--
--	complex c_sin(complex)			to	cnSin / :sin
--	complex c_cos(complex)			to	cnCos / :cos
--	complex c_tan(complex)			to	cnTan / :tan
--	complex c_sinh(complex)			to	cnSinh / :sinh
--	complex c_cosh(complex)			to	cnCosh / :cosh
--	complex c_tanh(complex)			to	cnTanh / :tanh
--

local M = require 'complex'

local cnAbs = M.cnAbs
local cnArg = M.cnArg
local cnConjugate = M.cnConjugate
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
local complexNumber = M.complexNumber
local complexNumberWIM = M.complexNumberWithInplaceMethod
local overloadOperator = M.overloadOperator

do
	local n1, n2, n3 = 1, -2, 3

	local a, b = complexNumber(n1, n2), complexNumber(n2, n3)
	local c, d = overloadOperator(a), overloadOperator(b)
	local e, f = complexNumberWIM(n1, n2), complexNumberWIM(n2, n3)

	assert("1-2i" == tostring(a) and "1-2i" == tostring(c) and "1-2i" == tostring(e))
	assert("-2+3i" == tostring(b) and "-2+3i" == tostring(d) and "-2+3i" == tostring(f))

	assert(a == c and b == d and c == e and d == f)
	assert(a:abs() == c:abs() and cnAbs(a) == cnAbs(c) and
		c:abs() == e:abs() and cnAbs(c) == cnAbs(e))
	assert(b:arg() == d:arg() and cnArg(b) == cnArg(d) and
		d:arg() == f:arg() and cnArg(d) == cnArg(f))
	assert(cnConjugate(a) == cnConjugate(c) and c == e:conjugate():conjugate())
	assert(cnConjugate(b) == cnConjugate(d) and d == f:conjugate():conjugate())

	assert(cnAdd(a, b) == c + d and cnAdd(b, a) == d + c)
	assert(cnSub(a, b) == c - d and cnSub(b, a) == d - c)
	assert(cnMul(a, b) == c * d and cnMul(b, a) == d * c)
	assert(cnDiv(a, b) == c / d and cnDiv(b, a) == d / c)
	assert(cnPow(a, b) == c ^ d and cnPow(b, a) == d ^ c)

	assert(e:add(f):sub(f) == c + d - d, c + d - d == cnSub(cnAdd(a, b), b))
	e:set(n1, n2) f:set(n2, n3)
	assert(e:mul(f):div(f) == c * d / d, c * d / d == cnDiv(cnMul(a, b), b))
	e:set(n1, n2) f:set(n2, n3)
	assert(e:pow(f):sqrt(f) == cnSqrt(cnPow(a, b), b))
	e:set(n1, n2) f:set(n2, n3)
	assert(e:exp():log():exp() == cnExp(cnLog(cnExp(a))) and
		f:log():exp():log() == cnLog(cnExp(cnLog(b))))
	e:set(n1, n2) f:set(n2, n3)

	assert(e:sin() == cnSin(a) and f:cos() == cnCos(b))
	e:set(n1, n2) f:set(n2, n3)
	assert(e:tan() == cnTan(a) and f:sinh() == cnSinh(b))
	e:set(n1, n2) f:set(n2, n3)
	assert(e:cosh() == cnCosh(a) and f:tanh() == cnTanh(b))

	e:set(-n2, n1) f:set(-n2, n1)

	print(("a, b, c, d, e, f : %s, %s, %s, %s, %s, %s"):format(a, b, c, d, e, f))
	print(("cnSub(a, cnExp(cnLog(a))), c - cnExp(cnLog(c)) = %s, %s")
		:format(cnSub(a, cnExp(cnLog(a))), c - cnExp(cnLog(c))))
	print(("cnSub(b, cnExp(cnLog(b))), d - cnExp(cnLog(d)) = %s, %s")
		:format(cnSub(b, cnExp(cnLog(b))), d - cnExp(cnLog(d))))
	print(("e:sub(f:log():exp()) = %s"):format(e:sub(f:log():exp())))
end

print("--")

do
	function toPolarForm(v)
		return ("%gxCis(%g(rad)) (%g(deg))")
			:format(v:abs(), v:arg(), math.deg(v:arg()))
	end

	function p(a, b, c, d)
		print(("%12s : %s"):format(a, toPolarForm(a)))
		print(("%12s : %s"):format(b, toPolarForm(b)))
		print(("%12s : %s"):format(c, toPolarForm(c)))
		print(("%12s : %s"):format(d, toPolarForm(d)))
	end

	local a, b = complexNumber(1, 1), complexNumber(-1, 1)
	local c, d = complexNumber(1, math.sqrt(3)), complexNumber(-1, math.sqrt(3))

	p(a, b, cnConjugate(b), cnConjugate(a))
	p(c, d, cnConjugate(d), cnConjugate(c))
end

print("--")

do
	function init(r, i) return overloadOperator(complexNumber(r, i)) end

	function getReciprocal(v)
		local r, i = v:get()
		if r == 0 and i == 0 then
			error("can't get the reciprocal of 0+0i")
		end
		local t = v:abs()
		return init(r / (t * t), -i / (t * t))
	end

	local a, b, c, d = init(2, 1), init(-1, 1), init(23, 45), init(1, 0)

	print(("a, b, c, d : %s, %s, %s, %s"):format(a, b, c, d))
	print(("d - a * getReciprocal(a) : %s"):format(d - a * getReciprocal(a)))
	print(("d - b * getReciprocal(b) : %s"):format(d - b * getReciprocal(b)))
	print(("d - c * getReciprocal(c) : %s"):format(d - c * getReciprocal(c)))
end
