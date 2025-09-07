--
--  from src/tarai.c
--
--    int tarai(int, int, int)  to  tarai
--    tarai                     to  taraiC
--    tarai                     to  tak(*)
--
--  *) https://en.wikipedia.org/wiki/Tak_(function)
--

local M = require 'something-recursive'
local H = require '_helper'

local tarai, taraiC, tak = M.tarai, M.taraiC, M.tak
local count, isFun, isNum, wrapWithValidator, gUnpackerWithCounter =
	H.count, H.isFun, H.isNum, H.wrapWithValidator, H.gUnpackerWithCounter

local unpacker, unpackerC = gUnpackerWithCounter(), gUnpackerWithCounter()

local function fw(f)
	return wrapWithValidator(f, {isNum, isNum, isNum}, {isNum}, unpacker)
end
local function fwC(f)
	return wrapWithValidator(f, {isFun, isFun, isFun}, {isNum}, unpackerC)
end

do
	function cnt(x, y, z)
		local C = 0
		function rec(x, y, z)
			C = C + 1
			if x <= y then return y end
			return rec(rec(x-1, y, z), rec(y-1, z, x), rec(z-1, x, y))
		end
		rec(x, y, z)
		return C
	end
	function cntC(x, y, z)
		local C = 0
		function rec(x, y, z)
			C = C + 1
			if x() <= y() then return y() end
			return rec(
				function() return rec(function() return x()-1 end, y, z) end,
				function() return rec(function() return y()-1 end, z, x) end,
				function() return rec(function() return z()-1 end, x, y) end
			)
		end
		rec(
			function() return x end,
			function() return y end,
			function() return z end
		)
		return C
	end

	function taraiW(x, y, z)
		function rec(x, y, z)
			if x <= y then return y end
			return fw(rec)(
				fw(rec)(x-1, y, z),
				fw(rec)(y-1, z, x),
				fw(rec)(z-1, x, y)
			)
		end
		return fw(rec)(x, y, z)
	end
	function taraiCW(x, y, z)
		function rec(x, y, z)
			if x() <= y() then return y() end
			return fwC(rec)(
				function() return fwC(rec)(function() return x()-1 end, y, z) end,
				function() return fwC(rec)(function() return y()-1 end, z, x) end,
				function() return fwC(rec)(function() return z()-1 end, x, y) end
			)
		end
		return fwC(rec)(
			function() return x end,
			function() return y end,
			function() return z end
		)
	end

	io.write(
		"tarai(10, 5, 0), taraiC(10, 5, 0), taraiW(10, 5, 0), taraiCW(10, 5, 0) = ",
		tarai(10, 5, 0), ", ", taraiC(10, 5, 0), ", ", taraiW(10, 5, 0), ", ", taraiCW(10, 5, 0), "\n",

		"cnt(10, 5, 0), count(tarai, 10, 5, 0), unpacker:get() = ",
		cnt(10, 5, 0), ", ", count(tarai, 10, 5, 0), ", ", unpacker:get(), "\n",

		"cntC(10, 5, 0), count(taraiC, 10, 5, 0), unpackerC:get() = ",
		cntC(10, 5, 0), ", ", count(taraiC, 10, 5, 0), ", ", unpackerC:get(), "\n--\n"
	)

	unpackerC:reset()

	io.write(
		"taraiC(100, 50, 0), taraiCW(100, 50, 0) = ",
		taraiC(100, 50, 0), ", ", taraiCW(100, 50, 0), "\n",

		"cntC(100, 50, 0), count(taraiC, 100, 50, 0), unpackerC:get() = ",
		cntC(100, 50, 0), ", ", count(taraiC, 100, 50, 0), ", ", unpackerC:get(), "\n--\n",

		"tak(10, 5, 0), count(tak, 10, 5, 0) = ",
		tak(10, 5, 0), ", ", count(tak, 10, 5, 0), "\n"
	)
end
