--
--  from src/egypfrac.c
--
--    a part of main    to  egyptianFraction
--    egyptianFraction  to  egyptianFractionT
--    egyptianFraction  to  egyptianFractionM (depends on lbc(*))
--    egyptianFraction  to  egyptianFractionCO
--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'egyptianfraction'

local egyptianFraction = M.egyptianFraction
local egyptianFractionT = M.egyptianFractionT
local egyptianFractionM = M.egyptianFractionM
local egyptianFractionCO = M.egyptianFractionCO

local i_read, i_write = io.read, io.write

local function demo_interactive()
	i_write("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...\n")

	i_write("2/5 = ")
	egyptianFraction(2, 5)
	i_write("3/5 = ")
	i_write(table.concat(egyptianFractionT(3, 5), " + "), "\n")
	i_write("20/30 = ")
	egyptianFractionCO(20, 30)

	i_write("numerator is > ")
	local n = i_read()
	i_write("denominator is > ")
	local d = i_read()
	i_write(("%s/%s = "):format(n, d))

	if egyptianFractionM ~= nil then
		egyptianFractionM(n, d)
	else
		egyptianFractionT(tonumber(n), tonumber(d))
	end
end

local function demo()
	function run(n, d)
		i_write(("%s/%s = "):format(n, d))
		egyptianFraction(n, d)

		i_write(("%s/%s = "):format(n, d))
		i_write(table.concat(egyptianFractionT(n, d), " + "), "\n")

		i_write(("%s/%s = "):format(n, d))
		egyptianFractionCO(n, d)

		if egyptianFractionM ~= nil then
			i_write(("%s/%s = "):format(n, d))
			egyptianFractionM(n, d)
		end
	end

	i_write("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...\n")
	run(2, 5)
	run(3, 5)
	run(10, 122)
end

do
	demo()

--
--	Note:
--	In some(most?) cases,
--	egyptianFraction, egyptianFractionT and egyptianFractionCO are fragile.
--
--	> egyptianFraction(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/-2439178059951708601
--	> egyptianFractionT(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/-2439178059951708601
--	> egyptianFractionM(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/34454310087467394631
--	> egyptianFractionCO(10, 122)
--	1/13 + 1/199 + 1/52603 + 1/4150560811 + 1/-2439178059951708601
--
end
