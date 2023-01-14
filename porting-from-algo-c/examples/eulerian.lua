--
--	from src/eulerian.c
--
--	Eulerian	to	eulerianNumber
--

local M = require 'eulerian'
local H = require '_helper'

local eulerianNumber, id, tableWriter = M.eulerianNumber, H.id, H.tableWriter

do
	local writer = tableWriter(
		{ 0, 10, 1, "L" },
		{ 0, 10, 1 },
		{ 3, 8 },
		{ id, id, function (k, n) return eulerianNumber(n, k) end },
		{ "d", "d", "d" }
	)

	writer()
end
