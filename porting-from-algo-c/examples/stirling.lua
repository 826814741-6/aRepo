--
--  from src/stirling.c
--
--    int Stirling1(int, int)   to  stirling1
--    int Stirling2(int, int)   to  stirling2
--

local M = require 'something-recursive'
local H = require '_helper'

local stirling1, stirling2 = M.stirling1, M.stirling2
local id, tableWriter = H.id, H.tableWriter

do
	print("-------- Stirling numbers of the first kind:")
	tableWriter(
		{ 0, 10, 1, "L" },
		{ 0, 10, 1 },
		{ 3, 8 },
		{ id, id, function (k, n) return stirling1(n, k) end },
		{ "d", "d", "d" }
	)()

	print("-------- Stirling numbers of the second kind:")
	tableWriter(
		{ 0, 10, 1, "L" },
		{ 0, 10, 1 },
		{ 3, 8 },
		{ id, id, function (k, n) return stirling2(n, k) end },
		{ "d", "d", "d" }
	)()
end
