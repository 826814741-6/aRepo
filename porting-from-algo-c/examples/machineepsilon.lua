--
--	from src/maceps.c
--
--	a part of main		to	machineEpsilon
--

local M = require 'machineepsilon'

local machineEpsilon = M.machineEpsilon

local FLT_EPSILON = 1.19209290e-07		-- from src/float.ie3
local DBL_EPSILON = 2.2204460492503131e-16	-- from src/float.ie3

do
	local iterator = machineEpsilon()

	print(" e              1 + e          (1 + e) - 1    e (%q)")
	print("-------------- -------------- -------------- ---------")

	function pfmt(e)
		print(
			("% -14g % -14g % -14g  %q")
				:format(
					e,
					1 + e,
					(1 + e) - 1,
					e
				)
		)
	end

	for e in iterator do
		pfmt(e)
		if e - FLT_EPSILON <= DBL_EPSILON then
			break
		end
	end

	print("^------- FLT_EPSILON")

	for e in iterator do
		pfmt(e)
	end
end
