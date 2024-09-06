--
--	from src/multiply.c
--
--	unsigned multiply(unsigned, unsigned)	to	iMulA, iMulB, iMulC
--

local M = require 'multiply'

local iMulA, iMulB, iMulC = M.iMulA, M.iMulB, M.iMulC

do
	print(("%s, %s, %s, %s -> %d, %d, %.2f, %.2f"):format(
		"2*3", "iMulA(2,3)", "2.1*3.1", "iMulA(2.1,3.1)", 2*3, iMulA(2,3), 2.1*3.1, iMulA(2.1,3.1)))
	print(("%s, %s, %s, %s -> %d, %d, %.2f, (_CAN'T_CALL_)"):format(
		"2*3", "iMulB(2,3)", "2.1*3.1", "iMulB(2.1,3.1)", 2*3, iMulB(2,3), 2.1*3.1))
	print(("%s, %s, %s, %s -> %d, %d, %.2f, (_CAN'T_CALL_)"):format(
		"2*3", "iMulC(2,3)", "2.1*3.1", "iMulC(2.1,3.1)", 2*3, iMulC(2,3), 2.1*3.1))

	--
	-- print(("%s, %s, %s, %s -> %d, %d, %.2f, %.2f"):format(
	-- 	"2*3", "iMulB(2,3)", "2.1*3.1", "iMulB(2.1,3.1)", 2*3, iMulB(2,3), 2.1*3.1, iMulB(2.1,3.1)))
	--
	-- ...
	-- lua: src/multiply.lua:19: number (local 'a') has no integer representation
	-- stack traceback:
	--         src/multiply.lua:19: in function 'multiply.iMulB'
	--         examples/multiply.lua:15: in main chunk
	--         [C]: in ?
	--
end
