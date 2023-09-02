--
--	from src/e.c
--
--	long double ee(void)	to	e
--	e			to	eR
--	e			to	eM (depends on lbc(*))
--	e			to	eMR (depends on lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local ret, M = pcall(require, "bc")

local function e()
	local r, a, n, prev = 0, 1, 1
	repeat
		r, a, n, prev = r + a, a / n, n + 1, r
	until r == prev
	return r, n
end

local eM = ret and function (digit)
	M.digits(digit)
	local r, a, n, prev = M.new(0), M.new(1), 1
	repeat
		r, a, n, prev = r + a, a / n, n + 1, r
	until r == prev
	return r, n
end or nil

local function rec(r, a, n, prev)
	if r ~= prev then
		return rec(r + a, a / n, n + 1, r)
	end
	return r, n
end

local function eR()
	return rec(0, 1, 1)
end

local eMR = ret and function (digit)
	M.digits(digit)
	return rec(M.new(0), M.new(1), 1)
end or nil

return {
	e = e,
	eR = eR,
	eM = eM,
	eMR = eMR
}
