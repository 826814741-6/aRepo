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

local abs = math.abs
local atan = math.atan
local cos = math.cos
local exp = math.exp
local log = math.log
local sin = math.sin
local sqrt = math.sqrt

local SQRT05 = sqrt(0.5)

local function complexNumber(real, imaginary)
	local T = {
		r = real ~= nil and real or 0,
		i = imaginary ~= nil and imaginary or 0
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
			if abs(b.r) >= abs(b.i) then
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
			local r, i = 0.5 * log(a.r * a.r + a.i * a.i), atan(a.i, a.r)
			-- mul(b, log(a))
			r, i = b.r * r - b.i * i, b.r * i + b.i * r
			-- exp(mul(b, log(a)))
			return complexNumber(exp(r) * cos(i), exp(r) * sin(i))
		end
	})

	function T:exp()
		return complexNumber(exp(T.r) * cos(T.i), exp(T.r) * sin(T.i))
	end

	function T:log()
		return complexNumber(0.5 * log(T.r * T.r + T.i * T.i), atan(T.i, T.r))
	end

	function T:sqrt()
		local w = sqrt(T:abs() + abs(T.r))
		if T.r >= 0 then
			return complexNumber(SQRT05 * w, SQRT05 * T.i / w)
		else
			return complexNumber(
				SQRT05 * abs(T.i) / w,
				T.i >= 0 and SQRT05 * w or -SQRT05 * w
			)
		end
	end

	function T:sin()
		local e = exp(T.i)
		local f = 1 / e
		return complexNumber(0.5 * sin(T.r) * (e + f), 0.5 * cos(T.r) * (e - f))
	end

	function T:cos()
		local e = exp(T.i)
		local f = 1 / e
		return complexNumber(0.5 * cos(T.r) * (f + e), 0.5 * sin(T.r) * (f - e))
	end

	function T:tan()
		local e = exp(2 * T.i)
		local f = 1 / e
		local d = cos(2 * T.r) + 0.5 * (e + f)
		return complexNumber(sin(2 * T.r) / d, 0.5 * (e - f) / d)
	end

	function T:sinh()
		local e = exp(T.r)
		local f = 1 / e
		return complexNumber(0.5 * (e - f) * cos(T.i), 0.5 * (e + f) * sin(T.i))
	end

	function T:cosh()
		local e = exp(T.r)
		local f = 1 / e
		return complexNumber(0.5 * (e + f) * cos(T.i), 0.5 * (e - f) * sin(T.i))
	end

	function T:tanh()
		local e = exp(2 * T.r)
		local f = 1 / e
		local d = 0.5 * (e + f) + cos(2 * T.i)
		return complexNumber(0.5 * (e - f) / d, sin(2 * T.i) / d)
	end

	function T:abs()
		if T.r == 0 then return abs(T.i) end
		if T.i == 0 then return abs(T.r) end
		if abs(T.r) < abs(T.i) then
			local t = T.r / T.i
			return abs(T.i) * sqrt(1 + t * t)
		else
			local t = T.i / T.r
			return abs(T.r) * sqrt(1 + t * t)
		end
	end

	function T:arg()
		return atan(T.i, T.r)
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

--------

local function complexNumberS(real, imaginary)
	local T = {
		r = real ~= nil and real or 0,
		i = imaginary ~= nil and imaginary or 0
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
		if T.r == 0 then return abs(T.i) end
		if T.i == 0 then return abs(T.r) end
		if abs(T.r) < abs(T.i) then
			local t = T.r / T.i
			return abs(T.i) * sqrt(1 + t * t)
		else
			local t = T.i / T.r
			return abs(T.r) * sqrt(1 + t * t)
		end
	end

	function T:arg()
		return atan(T.i, T.r)
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
	if abs(b.r) >= abs(b.i) then
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
	local r, i = 0.5 * log(a.r * a.r + a.i * a.i), atan(a.i, a.r)
	-- mul(b, log(a))
	r, i = b.r * r - b.i * i, b.r * i + b.i * r
	-- exp(mul(b, log(a)))
	return complexNumberS(exp(r) * cos(i), exp(r) * sin(i))
end

local function cnExp(c)
	return complexNumberS(exp(c.r) * cos(c.i), exp(c.r) * sin(c.i))
end

local function cnLog(c)
	return complexNumberS(0.5 * log(c.r * c.r + c.i * c.i), atan(c.i, c.r))
end

local function cnSqrt(c)
	local w = sqrt(c:abs() + abs(c.r))
	if c.r >= 0 then
		return complexNumberS(SQRT05 * w, SQRT05 * c.i / w)
	else
		return complexNumberS(
			SQRT05 * abs(c.i) / w,
			c.i >= 0 and SQRT05 * w or -SQRT05 * w
		)
	end
end

local function cnSin(c)
	local e = exp(c.i)
	local f = 1 / e
	return complexNumberS(0.5 * sin(c.r) * (e + f), 0.5 * cos(c.r) * (e - f))
end

local function cnCos(c)
	local e = exp(c.i)
	local f = 1 / e
	return complexNumberS(0.5 * cos(c.r) * (f + e), 0.5 * sin(c.r) * (f - e))
end

local function cnTan(c)
	local e = exp(2 * c.i)
	local f = 1 / e
	local d = cos(2 * c.r) + 0.5 * (e + f)
	return complexNumberS(sin(2 * c.r) / d, 0.5 * (e - f) / d)
end

local function cnSinh(c)
	local e = exp(c.r)
	local f = 1 / e
	return complexNumberS(0.5 * (e - f) * cos(c.i), 0.5 * (e + f) * sin(c.i))
end

local function cnCosh(c)
	local e = exp(c.r)
	local f = 1 / e
	return complexNumberS(0.5 * (e + f) * cos(c.i), 0.5 * (e - f) * sin(c.i))
end

local function cnTanh(c)
	local e = exp(2 * c.r)
	local f = 1 / e
	local d = 0.5 * (e + f) + cos(2 * c.i)
	return complexNumberS(0.5 * (e - f) / d, sin(2 * c.i) / d)
end

--------

local function overloadWithInplaceMethods(c)
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
		c.r, c.i = c.r * a.r - c.i * a.i, c.r * a.i + c.i * a.r
		return c
	end

	c.div = function (a)
		if abs(a.r) >= abs(a.i) then
			local w = a.i / a.r
			local d = a.r + a.i * w
			c.r, c.i = (c.r + c.i * w) / d, (c.i - c.r * w) / d
		else
			local w = a.r / a.i
			local d = a.r * w + a.i
			c.r, c.i = (c.r * w + c.i) / d, (c.i * w - c.r) / d
		end
		return c
	end

	c.pow = function (a)
		-- log(c)
		local r, i = 0.5 * log(c.r * c.r + c.i * c.i), atan(c.i, c.r)
		-- mul(a, log(c))
		r, i = a.r * r - a.i * i, a.r * i + a.i * r
		-- exp(mul(a, log(c)))
		c.r, c.i = exp(r) * cos(i), exp(r) * sin(i)
		return c
	end

	c.exp = function ()
		c.r, c.i = exp(c.r) * cos(c.i), exp(c.r) * sin(c.i)
		return c
	end

	c.log = function ()
		c.r, c.i = 0.5 * log(c.r * c.r + c.i * c.i), atan(c.i, c.r)
		return c
	end

	c.sqrt = function ()
		local w = sqrt(c:abs() + abs(c.r))
		if c.r >= 0 then
			c.r, c.i = SQRT05 * w, SQRT05 * c.i / w
		else
			c.r = SQRT05 * abs(c.i) / w
			c.i = c.i >= 0 and SQRT05 * w or -SQRT05 * w
		end
		return c
	end

	c.sin = function ()
		local e = exp(c.i)
		local f = 1 / e
		c.r, c.i = 0.5 * sin(c.r) * (e + f), 0.5 * cos(c.r) * (e - f)
		return c
	end

	c.cos = function ()
		local e = exp(c.i)
		local f = 1 / e
		c.r, c.i = 0.5 * cos(c.r) * (f + e), 0.5 * sin(c.r) * (f - e)
		return c
	end

	c.tan = function ()
		local e = exp(2 * c.i)
		local f = 1 / e
		local d = cos(2 * c.r) + 0.5 * (e + f)
		c.r, c.i = sin(2 * c.r) / d, 0.5 * (e - f) / d
		return c
	end

	c.sinh = function ()
		local e = exp(c.r)
		local f = 1 / e
		c.r, c.i = 0.5 * (e - f) * cos(c.i), 0.5 * (e + f) * sin(c.i)
		return c
	end

	c.cosh = function ()
		local e = exp(c.r)
		local f = 1 / e
		c.r, c.i = 0.5 * (e + f) * cos(c.i), 0.5 * (e - f) * sin(c.i)
		return c
	end

	c.tanh = function ()
		local e = exp(2 * c.r)
		local f = 1 / e
		local d = 0.5 * (e + f) + cos(2 * c.i)
		c.r, c.i = 0.5 * (e - f) / d, sin(2 * c.i) / d
		return c
	end
end

--------

local function cnAbs(c)
	if c.r == 0 then return abs(c.i) end
	if c.i == 0 then return abs(c.r) end
	if abs(c.r) < abs(c.i) then
		local t = c.r / c.i
		return abs(c.i) * sqrt(1 + t * t)
	else
		local t = c.i / c.r
		return abs(c.r) * sqrt(1 + t * t)
	end
end

local function cnArg(c)
	return atan(c.i, c.r)
end

--------

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
	overloadWithInplaceMethods = overloadWithInplaceMethods,
	cnAbs = cnAbs,
	cnArg = cnArg
}
