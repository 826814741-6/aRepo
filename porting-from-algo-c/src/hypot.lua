--
--	from src/hypot.c
--
--	double hypot0(double, double)		to	hypot0
--	double hypot1(double, double)		to	hypot1
--	double hypot2(double, double)		to	hypot2 (Moler-Morrison)
--	hypot2 (Moler-Morrison)			to	hypotM (depends on lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local H = require '_helper'

local abs = H.abs
local sqrt = math.sqrt

local function hypot0(x, y)
	return sqrt(x * x + y * y)
end

local function hypot1(x, y)
	if x == 0 then return abs(y) end
	if y == 0 then return abs(x) end
	return abs(x) < abs(y) and
		abs(y) * sqrt(1 + (x/y) * (x/y)) or
		abs(x) * sqrt(1 + (y/x) * (y/x))
end

local function hypot2(x, y)
	local a, b = abs(x), abs(y)
	if a < b then a, b = b, a end
	if b == 0 then return a end
	for _=1,3 do
		local t = (b/a)*(b/a) / (4 + (b/a)*(b/a))
		a, b = a + 2 * a * t, b * t
	end
	return a
end

local ret, M = pcall(require, "bc")

local hypotM = ret and function (x, y, digit)
	M.digits(digit)
	return hypot2(M.new(x), M.new(y))
end or nil

return {
	hypot0 = hypot0,
	hypot1 = hypot1,
	hypot2 = hypot2,
	hypotM = hypotM
}
