--
--	from src/hypot.c
--
--	double hypot0(double, double)		to	hypot0
--	double hypot1(double, double)		to	hypot1
--	double hypot2(double, double)		to	hypot2 (Moler-Morrison)
--	hypot2 (Moler-Morrison)			to	hypotM (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'hypot'

local hypot0, hypot1, hypot2, hypotM = M.hypot0, M.hypot1, M.hypot2, M.hypotM

do
	print(("%.14f %.20f %q"):format(hypot0(1,2), hypot0(1,2), hypot0(1,2)))
	print(("%.14f %.20f %q"):format(hypot1(1,2), hypot1(1,2), hypot1(1,2)))
	print(("%.14f %.20f %q"):format(hypot2(1,2), hypot2(1,2), hypot2(1,2)))
	if hypotM ~= nil then
		print(hypotM(1, 2, 50))
	end

	print("--------")

	print(("%.14f %.20f %q"):format(
		hypot0(1<<31,1<<31), hypot0(1<<31,1<<31), hypot0(1<<31,1<<31)))
	print(("%.14f %.20f %q"):format(
		hypot1(1<<31,1<<31), hypot1(1<<31,1<<31), hypot1(1<<31,1<<31)))
	print(("%.14f %.20f %q"):format(
		hypot2(1<<31,1<<31), hypot2(1<<31,1<<31), hypot2(1<<31,1<<31)))
	if hypotM ~= nil then
		print(hypotM(1<<31, 1<<31, 50))
	end
end
