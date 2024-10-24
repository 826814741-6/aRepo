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
--							/ overrideWithInplaceMethod
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

local function complexNumber(real, imaginary)
	local T = {
		r = isNum(real) and real or 0,
		i = isNum(imaginary) and imaginary or 0
	}

	setmetatable(T, {
		__tostring = function (v)
			return ("%g%+gi"):format(v.r, v.i)
		end,
		__eq = function (a, b)
			return a.r == b.r and a.i == b.i
		end,
		__add = function (a, b)
			return complexNumber(a.r + b.r, a.i + b.i)
		end,
		__sub = function (a, b)
			return complexNumber(a.r - b.r, a.i - b.i)
		end,
		__mul = function (a, b)
			return complexNumber(
				a.r * b.r - a.i * b.i,
				a.r * b.i + a.i * b.r
			)
		end,
		__div = function (a, b)
			if m_abs(b.r) >= m_abs(b.i) then
				local w = b.i / b.r
				local d = b.r + b.i * w
				return complexNumber(
					(a.r + a.i * w) / d,
					(a.i - a.r * w) / d
				)
			else
				local w = b.r / b.i
				local d = b.r * w + b.i
				return complexNumber(
					(a.r * w + a.i) / d,
					(a.i * w - a.r) / d
				)
			end
		end,
		__pow = function (a, b)
			-- log(a)
			local r, i =
				0.5 * m_log(a.r * a.r + a.i * a.i),
				m_atan(a.i, a.r)
			-- mul(b, log(a))
			r, i =
				b.r * r - b.i * i,
				b.r * i + b.i * r
			-- exp(mul(b, log(a)))
			return complexNumber(
				m_exp(r) * m_cos(i),
				m_exp(r) * m_sin(i)
			)
		end
	})

	function T:exp()
		return complexNumber(
			m_exp(T.r) * m_cos(T.i),
			m_exp(T.r) * m_sin(T.i)
		)
	end

	function T:log()
		return complexNumber(
			0.5 * m_log(T.r * T.r + T.i * T.i),
			m_atan(T.i, T.r)
		)
	end

	function T:sqrt()
		local w = m_sqrt(T:abs() + m_abs(T.r))
		if T.r >= 0 then
			return complexNumber(
				SQRT05 * w,
				SQRT05 * T.i / w
			)
		else
			return complexNumber(
				SQRT05 * m_abs(T.i) / w,
				(T.i >= 0 and SQRT05 or -SQRT05) * w
			)
		end
	end

	function T:sin()
		local e = m_exp(T.i)
		return complexNumber(
			0.5 * m_sin(T.r) * (e + 1 / e),
			0.5 * m_cos(T.r) * (e - 1 / e)
		)
	end

	function T:cos()
		local e = m_exp(T.i)
		return complexNumber(
			0.5 * m_cos(T.r) * (1 / e + e),
			0.5 * m_sin(T.r) * (1 / e - e)
		)
	end

	function T:tan()
		local e = m_exp(2 * T.i)
		local d = m_cos(2 * T.r) + 0.5 * (e + 1 / e)
		return complexNumber(
			m_sin(2 * T.r) / d,
			0.5 * (e - 1 / e) / d
		)
	end

	function T:sinh()
		local e = m_exp(T.r)
		return complexNumber(
			0.5 * (e - 1 / e) * m_cos(T.i),
			0.5 * (e + 1 / e) * m_sin(T.i)
		)
	end

	function T:cosh()
		local e = m_exp(T.r)
		return complexNumber(
			0.5 * (e + 1 / e) * m_cos(T.i),
			0.5 * (e - 1 / e) * m_sin(T.i)
		)
	end

	function T:tanh()
		local e = m_exp(2 * T.r)
		local d = 0.5 * (e + 1 / e) + m_cos(2 * T.i)
		return complexNumber(
			0.5 * (e - 1 / e) / d,
			m_sin(2 * T.i) / d
		)
	end

	function T:abs()
		if T.r == 0 then return m_abs(T.i) end
		if T.i == 0 then return m_abs(T.r) end
		if m_abs(T.r) < m_abs(T.i) then
			local t = T.r / T.i
			return m_abs(T.i) * m_sqrt(1 + t * t)
		else
			local t = T.i / T.r
			return m_abs(T.r) * m_sqrt(1 + t * t)
		end
	end

	function T:arg()
		return m_atan(T.i, T.r)
	end

	function T:conjugate()
		return complexNumber(T.r, -T.i)
	end

	function T:get()
		return T.r, T.i
	end

	function T:set(real, imaginary)
		T.r, T.i = real, imaginary
	end

	return T
end

--

local function complexNumberS(real, imaginary)
	local T = {
		r = isNum(real) and real or 0,
		i = isNum(imaginary) and imaginary or 0
	}

	setmetatable(T, {
		__tostring = function (v)
			return ("%g%+gi"):format(v.r, v.i)
		end,
		__eq = function (a, b)
			return a.r == b.r and a.i == b.i
		end
	})

	function T:abs()
		if T.r == 0 then return m_abs(T.i) end
		if T.i == 0 then return m_abs(T.r) end
		if m_abs(T.r) < m_abs(T.i) then
			local t = T.r / T.i
			return m_abs(T.i) * m_sqrt(1 + t * t)
		else
			local t = T.i / T.r
			return m_abs(T.r) * m_sqrt(1 + t * t)
		end
	end

	function T:arg()
		return m_atan(T.i, T.r)
	end

	function T:conjugate()
		return complexNumberS(T.r, -T.i)
	end

	function T:get()
		return T.r, T.i
	end

	function T:set(real, imaginary)
		T.r, T.i = real, imaginary
	end

	return T
end

local function cnAdd(a, b)
	return complexNumberS(a.r + b.r, a.i + b.i)
end

local function cnSub(a, b)
	return complexNumberS(a.r - b.r, a.i - b.i)
end

local function cnMul(a, b)
	return complexNumberS(a.r * b.r - a.i * b.i, a.r * b.i + a.i * b.r)
end

local function cnDiv(a, b)
	if m_abs(b.r) >= m_abs(b.i) then
		local w = b.i / b.r
		local d = b.r + b.i * w
		return complexNumberS((a.r + a.i * w) / d, (a.i - a.r * w) / d)
	else
		local w = b.r / b.i
		local d = b.r * w + b.i
		return complexNumberS((a.r * w + a.i) / d, (a.i * w - a.r) / d)
	end
end

local function cnPow(a, b)
	-- log(a)
	local r, i =
		0.5 * m_log(a.r * a.r + a.i * a.i),
		m_atan(a.i, a.r)
	-- mul(b, log(a))
	r, i =
		b.r * r - b.i * i,
		b.r * i + b.i * r
	-- exp(mul(b, log(a)))
	return complexNumberS(
		m_exp(r) * m_cos(i),
		m_exp(r) * m_sin(i)
	)
end

local function cnExp(c)
	return complexNumberS(
		m_exp(c.r) * m_cos(c.i),
		m_exp(c.r) * m_sin(c.i)
	)
end

local function cnLog(c)
	return complexNumberS(
		0.5 * m_log(c.r * c.r + c.i * c.i),
		m_atan(c.i, c.r)
	)
end

local function cnSqrt(c)
	local w = m_sqrt(c:abs() + m_abs(c.r))
	if c.r >= 0 then
		return complexNumberS(
			SQRT05 * w,
			SQRT05 * c.i / w
		)
	else
		return complexNumberS(
			SQRT05 * m_abs(c.i) / w,
			(c.i >= 0 and SQRT05 or -SQRT05) * w
		)
	end
end

local function cnSin(c)
	local e = m_exp(c.i)
	return complexNumberS(
		0.5 * m_sin(c.r) * (e + 1 / e),
		0.5 * m_cos(c.r) * (e - 1 / e)
	)
end

local function cnCos(c)
	local e = m_exp(c.i)
	return complexNumberS(
		0.5 * m_cos(c.r) * (1 / e + e),
		0.5 * m_sin(c.r) * (1 / e - e)
	)
end

local function cnTan(c)
	local e = m_exp(2 * c.i)
	local d = m_cos(2 * c.r) + 0.5 * (e + 1 / e)
	return complexNumberS(
		m_sin(2 * c.r) / d,
		0.5 * (e - 1 / e) / d
	)
end

local function cnSinh(c)
	local e = m_exp(c.r)
	return complexNumberS(
		0.5 * (e - 1 / e) * m_cos(c.i),
		0.5 * (e + 1 / e) * m_sin(c.i)
	)
end

local function cnCosh(c)
	local e = m_exp(c.r)
	return complexNumberS(
		0.5 * (e + 1 / e) * m_cos(c.i),
		0.5 * (e - 1 / e) * m_sin(c.i)
	)
end

local function cnTanh(c)
	local e = m_exp(2 * c.r)
	local d = 0.5 * (e + 1 / e) + m_cos(2 * c.i)
	return complexNumberS(
		0.5 * (e - 1 / e) / d,
		m_sin(2 * c.i) / d
	)
end

--

local function overrideWithInplaceMethod(c)
	c.conjugate = function ()
		c.i = -c.i
		return c
	end

	c.add = function (a)
		c.r, c.i = c.r + a.r, c.i + a.i
		return c
	end

	c.sub = function (a)
		c.r, c.i = c.r - a.r, c.i - a.i
		return c
	end

	c.mul = function (a)
		c.r, c.i =
			c.r * a.r - c.i * a.i,
			c.r * a.i + c.i * a.r
		return c
	end

	c.div = function (a)
		if m_abs(a.r) >= m_abs(a.i) then
			local w = a.i / a.r
			local d = a.r + a.i * w
			c.r, c.i =
				(c.r + c.i * w) / d,
				(c.i - c.r * w) / d
		else
			local w = a.r / a.i
			local d = a.r * w + a.i
			c.r, c.i =
				(c.r * w + c.i) / d,
				(c.i * w - c.r) / d
		end
		return c
	end

	c.pow = function (a)
		-- log(c)
		local r, i =
			0.5 * m_log(c.r * c.r + c.i * c.i),
			m_atan(c.i, c.r)
		-- mul(a, log(c))
		r, i =
			a.r * r - a.i * i,
			a.r * i + a.i * r
		-- exp(mul(a, log(c)))
		c.r, c.i =
			m_exp(r) * m_cos(i),
			m_exp(r) * m_sin(i)
		return c
	end

	c.exp = function ()
		c.r, c.i =
			m_exp(c.r) * m_cos(c.i),
			m_exp(c.r) * m_sin(c.i)
		return c
	end

	c.log = function ()
		c.r, c.i =
			0.5 * m_log(c.r * c.r + c.i * c.i),
			m_atan(c.i, c.r)
		return c
	end

	c.sqrt = function ()
		local w = m_sqrt(c:abs() + m_abs(c.r))
		if c.r >= 0 then
			c.r, c.i =
				SQRT05 * w,
				SQRT05 * c.i / w
		else
			c.r, c.i =
				SQRT05 * abs(c.i) / w,
				(c.i >= 0 and SQRT05 or -SQRT05) * w
		end
		return c
	end

	c.sin = function ()
		local e = m_exp(c.i)
		c.r, c.i =
			0.5 * m_sin(c.r) * (e + 1 / e),
			0.5 * m_cos(c.r) * (e - 1 / e)
		return c
	end

	c.cos = function ()
		local e = m_exp(c.i)
		c.r, c.i =
			0.5 * m_cos(c.r) * (1 / e + e),
			0.5 * m_sin(c.r) * (1 / e - e)
		return c
	end

	c.tan = function ()
		local e = m_exp(2 * c.i)
		local d = m_cos(2 * c.r) + 0.5 * (e + 1 / e)
		c.r, c.i =
			m_sin(2 * c.r) / d,
			0.5 * (e - 1 / e) / d
		return c
	end

	c.sinh = function ()
		local e = m_exp(c.r)
		c.r, c.i =
			0.5 * (e - 1 / e) * m_cos(c.i),
			0.5 * (e + 1 / e) * m_sin(c.i)
		return c
	end

	c.cosh = function ()
		local e = m_exp(c.r)
		c.r, c.i =
			0.5 * (e + 1 / e) * m_cos(c.i),
			0.5 * (e - 1 / e) * m_sin(c.i)
		return c
	end

	c.tanh = function ()
		local e = m_exp(2 * c.r)
		local d = 0.5 * (e + 1 / e) + m_cos(2 * c.i)
		c.r, c.i =
			0.5 * (e - 1 / e) / d,
			m_sin(2 * c.i) / d
		return c
	end
end

--

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

--

return {
	complexNumber = complexNumber,
	complexNumberS = complexNumberS,
	cnAdd = cnAdd,
	cnSub = cnSub,
	cnMul = cnMul,
	cnDiv = cnDiv,
	cnPow = cnPow,
	cnExp = cnExp,
	cnLog = cnLog,
	cnSqrt = cnSqrt,
	cnSin = cnSin,
	cnCos = cnCos,
	cnTan = cnTan,
	cnSinh = cnSinh,
	cnCosh = cnCosh,
	cnTanh = cnTanh,
	overrideWithInplaceMethod = overrideWithInplaceMethod,
	cnAbs = cnAbs,
	cnArg = cnArg
}
