--
--  from src/hypot.c
--
--    double hypot0(double, double)  to  hypot0
--    double hypot1(double, double)  to  hypot1
--    double hypot2(double, double)  to  hypot2 (Moler-Morrison)
--

local M = require 'hypot'

local hypot0, hypot1, hypot2 = M.hypot0, M.hypot1, M.hypot2

do
	print(("%.17f %q"):format(hypot0(1,2), hypot0(1,2)))
	print(("%.17f %q"):format(hypot1(1,2), hypot1(1,2)))
	print(("%.17f %q"):format(hypot2(1,2), hypot2(1,2)))

	local hasBC, bc = pcall(require, "bc") -- (*)
	if hasBC then
		bc.digits(50)
		print(hypot2(bc.new(1), bc.new(2)))
	end

	print("--")

	local n = math.pow(2, 512)
	print(("%f %q"):format(hypot0(n, n), hypot0(n, n)))
	print(("%f %q"):format(hypot1(n, n), hypot1(n, n)))
	print(("%f %q"):format(hypot2(n, n), hypot2(n, n)))

	if hasBC then
		local n = bc.new(2) ^ 512
		print(hypot2(n, n))
	end
end

--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--
