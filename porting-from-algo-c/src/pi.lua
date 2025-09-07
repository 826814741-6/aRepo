--
--  from src/pi1.c
--
--    long double pi(void)  to  machinLike
--    machinLike            to  machinLikeM (depends on lbc(*))
--
--  from src/pi2.c
--
--    a part of main        to  gaussLegendre
--    gaussLegendre         to  gaussLegendreM (depends on lbc(*))
--
--  from https://en.wikipedia.org/wiki/Leibniz_formula_for_%CF%80
--
--    a part of article     to  leibniz
--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local hasBC, bc = pcall(require, "bc")

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

local bn0 = hasBC and bc.new(0) or nil
local bn1 = hasBC and bc.new(1) or nil

local machinLikeM = hasBC and function (digit)
	bc.digits(digit)
	local bn2, bn5, bn239 = bn1 * 2, bn1 * 5, bn1 * 239

	local p, k, t, prev = bn0, bn1, 16 / bn5
	repeat
		p, k, t, prev = p + t/k, k + bn2, t / (-bn5 * bn5), p
	until p == prev
	k, t = bn1, 4 / bn239
	repeat
		p, k, t, prev = p - t/k, k + bn2, t / (-bn239 * bn239), p
	until p == prev
	return p
end or nil

local m_sqrt = math.sqrt

local function gaussLegendre(n)
	local a, b, t, u = 1, 1 / m_sqrt(2), 1, 4
	for _=1,n do
		local prev = a
		a, b = (a + b) / 2, m_sqrt(prev * b)
		t, u = t - u * (a - prev) * (a - prev), u * 2
	end
	return (a + b) * (a + b) / t
end

local bc_sqrt = hasBC and bc.sqrt or nil

local gaussLegendreM = hasBC and function (n, digit)
	bc.digits(digit)
	local bn2, bn4 = bn1 * 2, bn1 * 4

	local a, b, t, u = bn1, bn1 / bc_sqrt(2), bn1, bn4
	for _=1,n do
		local prev = a
		a, b = (a + b) / bn2, bc_sqrt(prev * b)
		t, u = t - u * (a - prev) * (a - prev), u * bn2
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
