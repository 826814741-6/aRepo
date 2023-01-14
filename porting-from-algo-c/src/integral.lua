--
--	from src/si.c
--
--	double Si_series(double)	to	seriesExpansion
--	double Si_asympt(double)	to	asymptoticExpansion
--	double Si(double)		to	Si
--
--	from src/ci.c
--
--	double Ci_series(double)	to	seriesExpansion
--	double Ci_asympt(double)	to	asymptoticExpansion
--	double Ci(double)		to	Ci
--

local H = require '_helper'

local EULER = 0.577215664901532860606512090082 -- from src/ci.c; see below
local PI = math.pi

--
-- In my environment(*), this numeric string is treated as:
--
-- > function fmt(n) return ("%.20f %.20g %q"):format(n, n, n) end
-- > fmt(0.577215664901532860606512090082)
-- 0.57721566490153286555 0.57721566490153286555 0x1.2788cfc6fb619p-1
--
-- *) I do not touch the value of LUA_32BITS in luaconf.h. (see manual 2.1)
--

local sin, cos, log = math.sin, math.cos, math.log
local id = H.id

local function seriesExpansion(r0, t0, k0)
	return function (x)
		local r, t = r0(x), t0(x)
		x = -x * x
		for k=k0,1000,2 do
			t = t * (x / ((k - 1) * k))
			local prev = r
			r = r + t / k
			if r == prev then return true, r end
		end
		return false, r
	end
end

local function asymptoticExpansion(aFunction)
	return function (x)
		local fmax, fmin, gmax, gmin = 2, 0, 2, 0
		local f, g, t = 0, 0, 1 / x
		local k, flag = 0, 0
		while flag ~= 15 do
			f, k = f + t, k + 1
			t = t * (k / x)
			if f < fmax then fmax = f else flag = flag | 1 end

			g, k = g + t, k + 1
			t = t * (k / x)
			if g < gmax then gmax = g else flag = flag | 2 end

			f, k = f - t, k + 1
			t = t * (k / x)
			if f > fmin then fmin = f else flag = flag | 4 end

			g, k = g - t, k + 1
			t = t * (k / x)
			if g > gmin then gmin = g else flag = flag | 8 end
		end
		return aFunction(fmax, fmin, gmax, gmin, x)
	end
end

local siS = seriesExpansion(
	id, id, 3
)
local ciS = seriesExpansion(
	function (x) return EULER + log(x) end, function (x) return 1 end, 2
)

local siA = asymptoticExpansion(function (fmax, fmin, gmax, gmin, x)
	return 0.5 * (PI - (fmax + fmin) * cos(x) - (gmax + gmin) * sin(x))
end)
local ciA = asymptoticExpansion(function (fmax, fmin, gmax, gmin, x)
	return 0.5 * ((fmax + fmin) * sin(x) - (gmax + gmin) * cos(x))
end)

local function Si(x)
	if x < 0 then return -Si(-x) end

	if x < 18 then
		local isConvergent, r = siS(x)
		if not isConvergent then
			io.stderr:write("Si (seriesExpansion): does not converge.")
		end
		return r
	else
		return siA(x)
	end
end

local function Ci(x)
	if x < 0 then return -Ci(-x) end

	if x < 18 then
		local isConvergent, r = ciS(x)
		if not isConvergent then
			io.stderr:write("Ci (seriesExpansion): does not converge.")
		end
		return r
	else
		return ciA(x)
	end
end

return {
	Si = Si,
	Ci = Ci
}
