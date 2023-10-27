--
--	from src/tarai.c
--
--	int tarai(int, int, int)	to	tarai
--	tarai				to	tak(*)
--
--	*) https://en.wikipedia.org/wiki/Tak_(function)
--

local M = require 'tarai'
local H = require '_helper'

local tarai, tak, count = M.tarai, M.tak, H.count

function taraiC(x, y, z)
	local _C = 0
	function t(x, y, z)
		_C = _C + 1
		if x() <= y() then return y() end
		return t(
			function() return t(function() return x()-1 end, y, z) end,
			function() return t(function() return y()-1 end, z, x) end,
			function() return t(function() return z()-1 end, x, y) end
		)
	end
	return t(
		function() return x end,
		function() return y end,
		function() return z end
	), _C
end

do
	print(("%s = %d (%d)"):format(
		"tarai(10, 5, 0)", tarai(10, 5, 0), count(tarai, 10, 5, 0)))
	print(("%s = %d (%d)"):format(
		"tak(10, 5, 0)", tak(10, 5, 0), count(tak, 10, 5, 0)))

	local r, c = taraiC(10, 5, 0)

	print(("%s = %d (%d) (%d)"):format(
		"taraiC(10, 5, 0)", r, count(taraiC, 10, 5, 0), c))
end
