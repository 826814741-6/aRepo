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

local isNum = require '_helper'.isNum

local m_abs = math.abs
local m_atan = math.atan
local m_cos = math.cos
local m_exp = math.exp
local m_log = math.log
local m_sin = math.sin
local m_sqrt = math.sqrt

local SQRT05 = m_sqrt(0.5)

--

local function toString(v) return ("%g%+gi"):format(v.r, v.i) end
local function eq(a, b) return a.r == b.r and a.i == b.i end

local function get(self) return self.r, self.i end
local function set(self, real, imaginary) self.r, self.i = real, imaginary end

local function cnAbs(c)
	if c.r == 0 then return m_abs(c.i) end
	if c.i == 0 then return m_abs(c.r) end
	if m_abs(c.r) < m_abs(c.i) then
		local t = c.r / c.i
		return m_abs(c.i) * m_sqrt(1 + t * t)
	else
		local t = c.i / c.r
		return m_abs(c.r) * m_sqrt(1 + t * t)
	end
end

local function cnArg(c)
	return m_atan(c.i, c.r)
end

local function init(real, imaginary)
	local T = {
		r = isNum(real) and real or 0,
		i = isNum(imaginary) and imaginary or 0
	}

	setmetatable(T, {
		__tostring = toString,
		__eq = eq
	})

	T.get, T.set = get, set
	T.abs, T.arg = cnAbs, cnArg

	return T
end

--

local function cnConjugateA(c)
	return init(c.r, -c.i)
end
local function cnConjugateB(self)
	self.i = -self.i
	return self
end

local function cnAddA(a, b)
	return init(a.r + b.r, a.i + b.i)
end
local function cnAddB(self, c)
	self.r, self.i = self.r + c.r, self.i + c.i
	return self
end

local function cnSubA(a, b)
	return init(a.r - b.r, a.i - b.i)
end
local function cnSubB(self, c)
	self.r, self.i = self.r - c.r, self.i - c.i
	return self
end

local function cnMulA(a, b)
	return init(a.r * b.r - a.i * b.i, a.r * b.i + a.i * b.r)
end
local function cnMulB(self, c)
	self.r, self.i =
		self.r * c.r - self.i * c.i,
		self.r * c.i + self.i * c.r
	return self
end

local function cnDivA(a, b)
	if m_abs(b.r) >= m_abs(b.i) then
		local w = b.i / b.r
		local d = b.r + b.i * w
		return init((a.r + a.i * w) / d, (a.i - a.r * w) / d)
	else
		local w = b.r / b.i
		local d = b.r * w + b.i
		return init((a.r * w + a.i) / d, (a.i * w - a.r) / d)
	end
end
local function cnDivB(self, c)
	if m_abs(c.r) >= m_abs(c.i) then
		local w = c.i / c.r
		local d = c.r + c.i * w
		self.r, self.i =
			(self.r + self.i * w) / d,
			(self.i - self.r * w) / d
	else
		local w = c.r / c.i
		local d = c.r * w + c.i
		self.r, self.i =
			(self.r * w + self.i) / d,
			(self.i * w - self.r) / d
	end
	return self
end

local function cnPowA(a, b)
	-- log(a)
	local r, i =
		0.5 * m_log(a.r * a.r + a.i * a.i),
		m_atan(a.i, a.r)
	-- mul(b, log(a))
	r, i =
		b.r * r - b.i * i,
		b.r * i + b.i * r
	-- exp(mul(b, log(a)))
	return init(
		m_exp(r) * m_cos(i),
		m_exp(r) * m_sin(i)
	)
end
local function cnPowB(self, c)
	-- log(self)
	local r, i =
		0.5 * m_log(self.r * self.r + self.i * self.i),
		m_atan(self.i, self.r)
	-- mul(c, log(self))
	r, i =
		c.r * r - c.i * i,
		c.r * i + c.i * r
	-- exp(mul(c, log(self)))
	self.r, self.i =
		m_exp(r) * m_cos(i),
		m_exp(r) * m_sin(i)
	return self
end

local function cnExpA(c)
	return init(
		m_exp(c.r) * m_cos(c.i),
		m_exp(c.r) * m_sin(c.i)
	)
end
local function cnExpB(self)
	self.r, self.i =
		m_exp(self.r) * m_cos(self.i),
		m_exp(self.r) * m_sin(self.i)
	return self
end

local function cnLogA(c)
	return init(
		0.5 * m_log(c.r * c.r + c.i * c.i),
		m_atan(c.i, c.r)
	)
end
local function cnLogB(self)
	self.r, self.i =
		0.5 * m_log(self.r * self.r + self.i * self.i),
		m_atan(self.i, self.r)
	return self
end

local function cnSqrtA(c)
	local w = m_sqrt(c:abs() + m_abs(c.r))
	if c.r >= 0 then
		return init(
			SQRT05 * w,
			SQRT05 * c.i / w
		)
	else
		return init(
			SQRT05 * m_abs(c.i) / w,
			(c.i >= 0 and SQRT05 or -SQRT05) * w
		)
	end
end
local function cnSqrtB(self)
	local w = m_sqrt(self:abs() + m_abs(self.r))
	if self.r >= 0 then
		self.r, self.i =
			SQRT05 * w,
			SQRT05 * self.i / w
	else
		self.r, self.i =
			SQRT05 * m_abs(self.i) / w,
			(self.i >= 0 and SQRT05 or -SQRT05) * w
	end
	return self
end

local function cnSinA(c)
	local e = m_exp(c.i)
	return init(
		0.5 * m_sin(c.r) * (e + 1 / e),
		0.5 * m_cos(c.r) * (e - 1 / e)
	)
end
local function cnSinB(self)
	local e = m_exp(self.i)
	self.r, self.i =
		0.5 * m_sin(self.r) * (e + 1 / e),
		0.5 * m_cos(self.r) * (e - 1 / e)
	return self
end

local function cnCosA(c)
	local e = m_exp(c.i)
	return init(
		0.5 * m_cos(c.r) * (1 / e + e),
		0.5 * m_sin(c.r) * (1 / e - e)
	)
end
local function cnCosB(self)
	local e = m_exp(self.i)
	self.r, self.i =
		0.5 * m_cos(self.r) * (1 / e + e),
		0.5 * m_sin(self.r) * (1 / e - e)
	return self
end

local function cnTanA(c)
	local e = m_exp(2 * c.i)
	local d = m_cos(2 * c.r) + 0.5 * (e + 1 / e)
	return init(
		m_sin(2 * c.r) / d,
		0.5 * (e - 1 / e) / d
	)
end
local function cnTanB(self)
	local e = m_exp(2 * self.i)
	local d = m_cos(2 * self.r) + 0.5 * (e + 1 / e)
	self.r, self.i =
		m_sin(2 * self.r) / d,
		0.5 * (e - 1 / e) / d
	return self
end

local function cnSinhA(c)
	local e = m_exp(c.r)
	return init(
		0.5 * (e - 1 / e) * m_cos(c.i),
		0.5 * (e + 1 / e) * m_sin(c.i)
	)
end
local function cnSinhB(self)
	local e = m_exp(self.r)
	self.r, self.i =
		0.5 * (e - 1 / e) * m_cos(self.i),
		0.5 * (e + 1 / e) * m_sin(self.i)
	return self
end

local function cnCoshA(c)
	local e = m_exp(c.r)
	return init(
		0.5 * (e + 1 / e) * m_cos(c.i),
		0.5 * (e - 1 / e) * m_sin(c.i)
	)
end
local function cnCoshB(self)
	local e = m_exp(self.r)
	self.r, self.i =
		0.5 * (e + 1 / e) * m_cos(self.i),
		0.5 * (e - 1 / e) * m_sin(self.i)
	return self
end

local function cnTanhA(c)
	local e = m_exp(2 * c.r)
	local d = 0.5 * (e + 1 / e) + m_cos(2 * c.i)
	return init(
		0.5 * (e - 1 / e) / d,
		m_sin(2 * c.i) / d
	)
end
local function cnTanhB(self)
	local e = m_exp(2 * self.r)
	local d = 0.5 * (e + 1 / e) + m_cos(2 * self.i)
	self.r, self.i =
		0.5 * (e - 1 / e) / d,
		m_sin(2 * self.i) / d
	return self
end

--

local function complexNumber(real, imaginary)
	return init(real, imaginary)
end

local function overloadOperator(v)
	return setmetatable(init(v.r, v.i), {
		__tostring = toString,
		__eq = eq,
		--
		__add = cnAddA,
		__sub = cnSubA,
		__mul = cnMulA,
		__div = cnDivA,
		__pow = cnPowA
	})
end

function complexNumberWithInplaceMethod(real, imaginary)
	local T = init(real, imaginary)

	T.conjugate = cnConjugateB
	T.add, T.sub, T.mul, T.div = cnAddB, cnSubB, cnMulB, cnDivB
	T.pow, T.exp, T.log, T.sqrt = cnPowB, cnExpB, cnLogB, cnSqrtB
	T.sin, T.cos, T.tan = cnSinB, cnCosB, cnTanB
	T.sinh, T.cosh, T.tanh = cnSinhB, cnCoshB, cnTanhB

	return T
end


return {
	cnAbs = cnAbs,
	cnArg = cnArg,
	cnConjugate = cnConjugateA,
	cnAdd = cnAddA,
	cnSub = cnSubA,
	cnMul = cnMulA,
	cnDiv = cnDivA,
	cnPow = cnPowA,
	cnExp = cnExpA,
	cnLog = cnLogA,
	cnSqrt = cnSqrtA,
	cnSin = cnSinA,
	cnCos = cnCosA,
	cnTan = cnTanA,
	cnSinh = cnSinhA,
	cnCosh = cnCoshA,
	cnTanh = cnTanhA,
	complexNumber = complexNumber,
	complexNumberWithInplaceMethod = complexNumberWithInplaceMethod,
	overloadOperator = overloadOperator
}
