--
--  from src/acker.c
--
--    int A(int, int)           to  ack
--

local H = require '_helper'

local ack = require 'something-recursive'.ack
local count, isNum, makeValidator, wrapWithValidator, gUnpackerWithCounter =
	H.count, H.isNum, H.makeValidator, H.wrapWithValidator, H.gUnpackerWithCounter

local unpacker = gUnpackerWithCounter()
local vP, vR = makeValidator({isNum, isNum}), makeValidator({isNum})

local function fw(f)
	return wrapWithValidator(f, vP, vR, unpacker)
end

do
	function cnt(x, y)
		local C = 0
		function ack(x, y)
			C = C + 1
			if x == 0 then return y + 1 end
			if y == 0 then return ack(x - 1, 1) end
			return ack(x - 1, ack(x, y - 1))
		end
		ack(x, y)
		return C
	end

	function ackW(x, y)
		function ack(x, y)
			if x == 0 then return y + 1 end
			if y == 0 then return fw(ack)(x - 1, 1) end
			return fw(ack)(x - 1, fw(ack)(x, y - 1))
		end
		return fw(ack)(x, y)
	end

	io.write(
		"ack(3, 3), ackW(3, 3) = ", ack(3, 3), ", ", ackW(3, 3), "\n",

		"cnt(3, 3), count(ack, 3, 3), unpacker:get() = ",
		cnt(3, 3), ", ", count(ack, 3, 3), ", ", unpacker:get(), "\n"
	)
end
