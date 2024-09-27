--
--	from src/acker.c
--
--	int A(int, int)		to	ack
--

local ack = require 'acker'.ack
local count = require '_helper'.count

function cnt(x, y)
	local _C = 0
	function ack(x, y)
		_C = _C + 1
		if x == 0 then return y+1 end
		if y == 0 then return ack(x-1,1) end
		return ack(x-1, ack(x,y-1))
	end
	ack(x, y)
	return _C
end

do
	print(("%s = %d, %d (%d)"):format("ack(3,3)", ack(3,3), count(ack,3,3), cnt(3,3)))
end
