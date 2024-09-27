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

local hasBC, bc = pcall(require, "bc")

local function loop(r0, a0)
	local r, a, n, prev = r0, a0, 1
	repeat
		r, a, n, prev = r + a, a / n, n + 1, r
	until r == prev
	return r, n - 1
end

local function rec(r, a, n, prev)
	if r ~= prev then
		return rec(r + a, a / n, n + 1, r)
	end
	return r, n - 1
end

local function e()
	return loop(0, 1)
end

local eM = hasBC and function (digit)
	bc.digits(digit)
	return loop(bc.new(0), bc.new(1))
end or nil

local function eR()
	return rec(0, 1, 1)
end

local eMR = hasBC and function (digit)
	bc.digits(digit)
	return rec(bc.new(0), bc.new(1), 1)
end or nil

return {
	e = e,
	eR = eR,
	eM = eM,
	eMR = eMR
}
