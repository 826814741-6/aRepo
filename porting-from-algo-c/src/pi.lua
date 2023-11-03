--
--	from src/pi1.c
--
--	long double pi(void)	to	machinLike
--	machinLike		to	machinLikeM (depends on lbc(*))
--
--	from src/pi2.c
--
--	a part of main		to	gaussLegendre
--	gaussLegendre		to	gaussLegendreM (depends on lbc(*))
--
--	from https://en.wikipedia.org/wiki/Leibniz_formula_for_%CF%80
--
--	a part of article	to	leibniz
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local hasBC, M = pcall(require, "bc")

local function machinLike()
	local p, k, t, prev = 0, 1, 16 / 5
	repeat
		p, k, t, prev = p + t/k, k + 2, t / (-5 * 5), p
	until p == prev
	k, t = 1, 4 / 239
	repeat
		p, k, t, prev = p - t/k, k + 2, t / (-239 * 239), p
	until p == prev
	return p
end

local machinLikeM = hasBC and function (digit)
	M.digits(digit)
	local _0, _1 = M.new(0), M.new(1)
	local _2, _5, _239 = _1*2, _1*5, _1*239

	local p, k, t, prev = _0, _1, 16 / _5
	repeat
		p, k, t, prev = p + t/k, k + _2, t / (-_5 * _5), p
	until p == prev
	k, t = _1, 4 / _239
	repeat
		p, k, t, prev = p - t/k, k + _2, t / (-_239 * _239), p
	until p == prev
	return p
end or nil

local sqrt = math.sqrt

local function gaussLegendre(n)
	local a, b, t, u = 1, 1 / sqrt(2), 1, 4
	for _=1,n do
		local prev = a
		a, b = (a + b) / 2, sqrt(prev * b)
		t, u = t - u * (a - prev) * (a - prev), u * 2
	end
	return (a + b) * (a + b) / t
end

local M_sqrt = hasBC and M.sqrt or nil

local gaussLegendreM = hasBC and function (n, digit)
	M.digits(digit)
	local _1 = M.new(1)
	local _2, _4 = _1*2, _1*4

	local a, b, t, u = _1, _1 / M_sqrt(2), _1, _4
	for _=1,n do
		local prev = a
		a, b = (a + b) / _2, M_sqrt(prev * b)
		t, u = t - u * (a - prev) * (a - prev), u * _2
	end
	return (a + b) * (a + b) / t
end or nil

local function leibniz(n)
	local r, sign, x = 0, 1, 1
	for _=1,n do
		r, sign, x = r + sign / x, sign * -1, x + 2
	end
	return r * 4
end

return {
	machinLike = machinLike,
	machinLikeM = machinLikeM,
	gaussLegendre = gaussLegendre,
	gaussLegendreM = gaussLegendreM,
	leibniz = leibniz
}
