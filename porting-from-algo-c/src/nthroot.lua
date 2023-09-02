--
--	from src/sqrt.c
--
--	double mysqrt(double)		to	fSqrt
--	fSqrt				to	fSqrtM (depends on lbc(*))
--
--	from src/isqrt.c
--
--	unsigned isqrt(unsigned)	to	iSqrt
--
--	from src/cuberoot.c
--
--	double cuberoot(double)		to	fCbrt
--	double cuberoot2(double)	to	fCbrt2
--	fCbrt				to	fCbrtM (depends on lbc(*))
--
--	from src/icubrt.c
--
--	unsigned icubrt(unsigned)	to	iCbrt
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local H = require '_helper'
local ret, M = pcall(require, "bc")

local abs, atLeastOne = H.abs, H.atLeastOne

local function loopF(x, step)
	local prev, t = atLeastOne(x), step(x, atLeastOne(x))
	while t < prev do
		prev, t = t, step(x, t)
	end
	return prev
end

local function fSqrt(x)
	if x <= 0 then return 0 end
	return loopF(x, function (x,t) return (x/t + t) / 2 end)
end

local fSqrtM = ret and function (x, digit)
	M.digits(digit)
	return fSqrt(M.new(x))
end or nil

local function _f(step, isZero)
	return function (x)
		if isZero(x) then
			return 0
		elseif x > 0 then
			return loopF(x, step)
		else
			return -loopF(abs(x), step)
		end
	end
end

local fCbrt = _f(
	function (x, t) return (x / (t*t) + 2*t) / 3 end,
	function (x) return x == 0 end
)

local fCbrt2 = _f(
	function (x, t) return t + (x - t*t*t) / (2*t*t + x/t) end,
	function (x) return x == 0 end
)

local fCbrtM = ret and (function (f)
	return function (x, digit)
		M.digits(digit)
		return f(M.new(x))
	end
end)(_f(
	function (x, t) return (x / (t*t) + 2*t) / 3 end,
	M.iszero
)) or nil

local function iSqrt(x)
	if x <= 0 then return 0 end

	local r, t = x, 1
	while t < r do
		r, t = r >> 1, t << 1
	end
	repeat
		r, t = t, (x // t + t) >> 1
	until t >= r

	return r
end

local function iCbrt(x)
	if x <= 0 then return 0 end

	local r, t = x, 1
	while t < r do
		r, t = r >> 2, t << 1
	end
	repeat
		r, t = t, (x // (t * t) + 2 * t) // 3
	until t >= r

	return r
end

return {
	fSqrt = fSqrt,
	fSqrtM = fSqrtM,
	iSqrt = iSqrt,
	fCbrt = fCbrt,
	fCbrt2 = fCbrt2,
	fCbrtM = fCbrtM,
	iCbrt = iCbrt
}
