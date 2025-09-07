--
--  from src/sum.c
--
--    float sum1(int, float[])  to  sum1
--    float sum2(int, float[])  to  sum2
--

local M = require 'sum'

local sum1, sum2 = M.sum1, M.sum2

do
	local a, n = {}, 10000
	for i=1,n do a[i] = 1/n end

	assert(0.0001 == 1/n)

	print(("1.0 == %s : %q (%q)"):format("sum1(a)", 1.0 == sum1(a), sum1(a)))
	print(("1.0 == %s : %q (%q)"):format("sum2(a)", 1.0 == sum2(a), sum2(a)))
end
