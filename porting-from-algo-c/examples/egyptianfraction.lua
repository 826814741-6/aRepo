--
--	from src/egypfrac.c
--
--	a part of main		to	egyptianFraction
--	egyptianFraction	to	egyptianFractionB
--	egyptianFraction	to	egyptianFractionM (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'egyptianfraction'

local egyptianFraction = M.egyptianFraction
local egyptianFractionB = M.egyptianFractionB
local egyptianFractionM = M.egyptianFractionM

local read, write = io.read, io.write

do
	write("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...\n")

	write("e.g. 2/5 = ")
	egyptianFraction(2, 5)
	write("e.g. 20/30 = ")
	egyptianFractionB(20, 30)

	write("numerator is > ")
	local n = read()
	write("denominator is > ")
	local d = read()
	write(("%s/%s = "):format(n, d))

	if egyptianFractionM ~= nil then
		egyptianFractionM(n, d)
	else
		egyptianFractionB(tonumber(n), tonumber(d))
	end

--
--	Note:
--	In some(most?) cases, egyptianFraction and egyptianFractionB are fragile.
--
--	> egyptianFraction(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/-2439178059951708601
--	> egyptianFractionB(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/-2439178059951708601
--	> egyptianFractionM(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/34454310087467394631
--
end
