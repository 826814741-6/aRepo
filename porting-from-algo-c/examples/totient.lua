--
--	from src/totient.c
--
--	unsigned phi(unsigned)		to	phi
--

local M = require 'totient'
local H = require '_helper'

local phi, id, tableWriter = M.phi, H.id, H.tableWriter

do
	local writer = tableWriter(
		{ 1, 10, 1 },
		{ 0, 19, 1 },
		{ 4, 4 },
		{ function (n) return n*10 end, id, function (i, j) return phi(10 * j + i) end },
		{ "d", "d", "d" }
	)

	writer()
end
