--
--	from src/change.c
--
--	int change(int, int)		to	changeR
--	int change1(int, int)		to	changeL
--

local M = require 'change'

local changeR, changeL = M.changeR, M.changeL

for i=0,500,5 do
	local a, b = changeR(i, i), changeL(i)

	assert(a == b, ("changeR(i,i) ~= changeL(i) (i:%d, changeR:%d, changeL:%d)"):format(i, a, b))

	print(("%4d %8d"):format(i, a))
end
