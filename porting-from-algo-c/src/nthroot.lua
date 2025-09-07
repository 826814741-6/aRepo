--
--  from src/sqrt.c
--
--    double mysqrt(double)      to  fSqrt
--    fSqrt                      to  fSqrtM (depends on lbc(*))
--
--  from src/isqrt.c
--
--    unsigned isqrt(unsigned)   to  iSqrt
--
--  from src/cuberoot.c
--
--    double cuberoot(double)    to  fCbrt
--    double cuberoot2(double)   to  fCbrt2
--    fCbrt                      to  fCbrtM (depends on lbc(*))
--
--  from src/icubrt.c
--
--    unsigned icubrt(unsigned)  to  iCbrt
--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local H = require '_helper'
local hasBC, bc = pcall(require, "bc")

local abs, atLeastOne = H.abs, H.atLeastOne

local function gLoop(step)
	return function (x)
		local prev, t = atLeastOne(x), step(x, atLeastOne(x))
		while t < prev do
			prev, t = t, step(x, t)
		end
		return prev
	end
end

local loopS, loopC1, loopC2 =
	gLoop(function (x, t) return (x/t + t) / 2 end),
	gLoop(function (x, t) return (x / (t*t) + 2*t) / 3 end),
	gLoop(function (x, t) return t + (x - t*t*t) / (2*t*t + x/t) end)

local function initC(isZero, loop)
	return function (x)
		if isZero(x) then
			return 0
		elseif x > 0 then
			return loop(x)
		else
			return -loop(abs(x))
		end
	end
end

local function isZero(x) return x == 0 end

--

local function fSqrt(x)
	if x <= 0 then return 0 end
	return loopS(x)
end

local fSqrtM = hasBC and function (x, digit)
	bc.digits(digit)
	return fSqrt(bc.new(x))
end or nil

local fCbrt, fCbrt2 = initC(isZero, loopC1), initC(isZero, loopC2)

local fCbrtM = hasBC and (function (f)
	return function (x, digit)
		bc.digits(digit)
		return f(bc.new(x))
	end
end)(initC(bc.iszero, loopC1)) or nil

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

local function loopI(x)
	local r, t = x, 1
	while t < r do
		r, t = r >> 2, t << 1
	end
	repeat
		r, t = t, (x // (t * t) + 2 * t) // 3
	until t >= r
	return r
end

local iCbrt = initC(isZero, loopI)

return {
	fSqrt = fSqrt,
	fSqrtM = fSqrtM,
	iSqrt = iSqrt,
	fCbrt = fCbrt,
	fCbrt2 = fCbrt2,
	fCbrtM = fCbrtM,
	iCbrt = iCbrt
}
