--
--	from src/e.c
--
--	long double ee(void)	to	e
--	e			to	eR
--	e			to	eM (depends lbc(*))
--	e			to	eMR (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/)
--

local M = require 'e'

local e, eR, eM, eMR = M.e, M.eR, M.eM, M.eMR

do
	local r1, n1 = e()
	local r2, n2 = eR()
	assert(r1 == r2)
	assert(n1 == n2)

	local r3, r4, n3, n4
	if eM ~= nil and eMR ~= nil then
		r3, n3 = eM(50)
		r4, n4 = eMR(50)
		assert(r3 == r4)
		assert(n3 == n4)
	end

	print(("%.14f\n%.18f %q (%d)%s"):format(
		r1, r1, r1, n1,
		r3 == nil and "" or "\n"..tostring(r3)..(" (%d)"):format(n3)))
end
