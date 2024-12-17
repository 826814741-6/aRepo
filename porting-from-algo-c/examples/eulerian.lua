--
--	from src/eulerian.c
--
--	Eulerian	to	eulerianNumber
--

local M = require 'something-recursive'
local H = require '_helper'

local eulerianNumber = M.eulerianNumber
local id, tableWriter = H.id, H.tableWriter

do
	tableWriter(
		{ 0, 10, 1, "L" },
		{ 0, 10, 1 },
		{ 3, 8 },
		{ id, id, function (k, n) return eulerianNumber(n, k) end },
		{ "d", "d", "d" }
	)()
end
