--
--  from src/e.c
--
--    long double ee(void)  to  e
--    e                     to  eR
--    e                     to  eM (depends on lbc(*))
--    e                     to  eMR (depends on lbc(*))
--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'e'

local e, eR, eM, eMR = M.e, M.eR, M.eM, M.eMR

do
	local r1, n1 = e()
	local r2, n2 = eR()
	assert(r1 == r2)
	assert(n1 == n2)
	print(("%.14f\n%.18f %q (%d)"):format(r1, r1, r1, n1))

	if eM ~= nil and eMR ~= nil then
		local r3, n3 = eM(50)
		local r4, n4 = eMR(50)
		assert(r3 == r4)
		assert(n3 == n4)
		print(("%s (%d)"):format(r3, n3))
	end
end
