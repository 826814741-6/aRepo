--
--  fun-with-calling-thru-metamethod.lua
--
--  > lua[jit] fun-with-calling-thru-metamethod.lua
--

local t_unpack = table.unpack ~= nil and table.unpack or unpack

function check(preds, target)
	for i,v in ipairs(preds) do
		assert(v(target[i]), i)
	end
end

function wrapWithPreds(body, forArg, forRet, unpacker)
	unpacker = unpacker ~= nil and unpacker or t_unpack
	return setmetatable({}, {
		__call = function (self, ...)
			local arg = {...}
			check(forArg, arg)

			local ret = {body(...)}
			check(forRet, ret)

			return unpacker(ret)
		end
	})
end

function isBool(v) return type(v) == "boolean" end
function isFh(v) return io.type(v) == "file" end
function isFun(v) return type(v) == "function" end
function isNum(v) return type(v) == "number" end
function isStr(v) return type(v) == "string" end
function isTbl(v) return type(v) == "table" end
function isNumOrNil(v) return isNum(v) or v == nil end
function isNumAndNonNeg(v) return isNum(v) and v >= 0 end
--
-- > v1, v2 = -0, -0.0
-- > = v1 == -v1 and v1 == v2 and v1 == -v2 and -v1 == v2 and -v1 == -v2 and v2 == -v2
-- true
--
-- > = v1+v1, v1-v1, v1+v2, v1-v2, -v1+v2, -v1-v2, v2+v2, v2-v2
-- 0       0       0.0     0.0     0.0     0.0     -0.0    0.0  -- v5.3+ (v5.4.8)
-- -0      0       -0      0       0       0       -0      0    --       (v2.1.1767980792)
--
-- >> The main difference between Lua 5.2 and Lua 5.3 is the introduction of
-- >> an integer subtype for numbers. ...
-- >> -- 8.1 - Changes in the Language (Lua 5.3 Reference Manual)
-- >> -- https://www.lua.org/manual/5.3/manual.html#8.1
--
-- cf. in the case of v2.1.1767976677- and LJ_DUALNUM == 1 (lj_arch.h)
-- (see: https://github.com/LuaJIT/LuaJIT/commit/707c12bf00dafdfd3899b1a6c36435dbbf6c7022)
--

do
	function f1(n, s, t) return n end
	function f2() return true, false end
	function f3(fh) end
	function f4(n) return 0, nil, 1 end
	function f5(n) return n < 0 and -n or n end
	function f6(n) return function (x, y) return "valid?" end end

	local w1 = wrapWithPreds(f1, {isNum, isStr, isTbl}, {isNum})
	local w2 = wrapWithPreds(f2, {}, {isBool, isBool})
	local w3 = wrapWithPreds(f3, {isFh}, {})
	local w4A = wrapWithPreds(
		f4,
		{isNumOrNil},
		{isNumOrNil, isNumOrNil, isNumOrNil}
	)
	local w4B = wrapWithPreds(
		f4,
		{isNumOrNil},
		{isNumOrNil, isNumOrNil, isNumOrNil},
		function (r) return r[1], r[2], r[3] end
	)
	local w5A = wrapWithPreds(f5, {isNum}, {isNumAndNonNeg})
	local w5B = wrapWithPreds(math.abs, {isNum}, {isNumAndNonNeg})
	local w6 = wrapWithPreds(f6, {isNum}, {isFun})
	local w7 = wrapWithPreds(w6(0), {isNum, isNum}, {isStr})

	print(w1(os.clock(), "1", {2}))
	print(w2())
	print(w3(io.stdout))
	print("t_unpack:", w4A())
	print("user unpacker:", w4B())
	print("bogus one:", w5A(-1), w5A(-0.1), w5A(-0.0), w5A(-0), w5A(0), w5A(0.0), w5A(0.1), w5A(1))
	print("math.abs:", w5B(-1), w5B(-0.1), w5B(-0.0), w5B(-0), w5B(0), w5B(0.0), w5B(0.1), w5B(1))
	print(w6(0))
	print(w7(1, 2))

	print("^-- ok / raise an error --v")

	local ret, err = pcall(w1, 1, 2, {})
	assert(ret, err)  -- (*)
	--
	-- If you want to see the results of the latter half,
	-- please comment out above line (line number: 93).
	--
end

--

function makePreds(preds, checker)
	local T = { preds = preds }

	T.check = checker ~= nil
		and checker
		or function (self, target)
			for i,v in ipairs(self.preds) do
				assert(v(target[i]), i)
			end
		end

	return T
end

function wrapWithPreds(body, forArg, forRet, unpacker)
	unpacker = unpacker ~= nil and unpacker or t_unpack
	return setmetatable({}, {
		__call = function (self, ...)
			local arg = {...}
			forArg:check(arg)

			local ret = {body(...)}
			forRet:check(ret)

			return unpacker(ret)
		end
	})
end

function gCheckVerbose(header)
	return function (self, target)
		io.write(header, "(", os.clock(), ") ")
		for i,v in ipairs(self.preds) do
			io.write(" ", i, ":", tostring(target[i]))
			assert(v(target[i]), i)
		end
		io.write("\n")
	end
end

function gUnpackerWithCounter(unpacker)
	unpacker = unpacker ~= nil and unpacker or function (r) return r[1] end
	local T = { c = 0 }
	function T:get() return T.c end
	function T:reset() T.c = 0 end
	return setmetatable(T, {
		__call = function (self, r)
			self.c = self.c + 1
			return unpacker(r)
		end
	})
end

do
	local checkA, checkR = gCheckVerbose("[arg]"), gCheckVerbose("[return]")
	local unpacker = gUnpackerWithCounter()

	local pA1 = makePreds({isNum}, checkA)
	local pA2 = makePreds({isNum, isNum}, checkA)
	local pA3 = makePreds({isNum, isNum, isNum}, checkA)
	local pA4 = makePreds({isNum, isFun}, checkA)
	local pA5 = makePreds({isNum, isTbl}, checkA)
	local pR = makePreds({isNum}, checkR)
	local pEmpty = makePreds({})

	function fw1(f) return wrapWithPreds(f, pA1, pR, unpacker) end
	function fw2(f) return wrapWithPreds(f, pA2, pR, unpacker) end
	function fw3(f) return wrapWithPreds(f, pA3, pR, unpacker) end
	function fw4(f) return wrapWithPreds(f, pA4, pEmpty, unpacker) end
	function fw5A(f) return wrapWithPreds(f, pA5, pEmpty, unpacker) end
	function fw5B(f) return wrapWithPreds(f, pA1, pEmpty, unpacker) end

	function fac1(n)
		if n > 0 then
			return n * fw1(fac1)(n - 1)
		else
			return 1
		end
	end
	function fac2(n)
		function rec(n, acc)
			if n > 0 then
				return fw2(rec)(n - 1, acc * n)
			else
				return acc
			end
		end
		return fw2(rec)(n, 1)
	end
	function fib(n)
		function rec(a, b, c)
			if c > 0 then
				return fw3(rec)(b, a + b, c - 1)
			else
				return a
			end
		end
		return fw3(rec)(0, 1, n)
	end
	function fac4(n)
		function rec(n, c)
			if n > 0 then
				fw4(rec)(n - 1, function (x) c(x * n) end)
			else
				c(1)
			end
		end
		local ret
		fw4(rec)(n, function (x) ret = x end)
		return ret
	end
	function fac5(n)
		function rec(n, c)
			if n > 0 then
				fw5A(rec)(n - 1, fw5B(function (x) c(x * n) end))
			else
				c(1)
			end
		end
		local ret
		fw5A(rec)(n, fw5B(function (x) ret = x end))
		return ret
	end

	assert(
		3628800 == fw1(fac1)(10)
		and 11 == unpacker:get() -- 11: 10...0
	)
	unpacker:reset()
	assert(
		3628800 == fac2(10)
		and 11 == unpacker:get() -- 11: 10...0
	)
	unpacker:reset()
	assert(
		55 == fib(10)
		and 11 == unpacker:get() -- 11: 10...0
	)
	unpacker:reset()
	assert(
		3628800 == fac4(10)
		and 11 == unpacker:get() -- 11: 10...0
	)
	unpacker:reset()
	assert(
		3628800 == fac5(10)
		and 22 == unpacker:get() -- 11: 10...0 x 2 (fw5A and fw5B)
	)

	print("--")

	function count(f, ...)
		local c = 0
		debug.sethook(function() c = c + 1 end, "c")
		f(...)
		debug.sethook()
		return c
	end

	function ack(x, y)
		if x == 0 then return y + 1 end
		if y == 0 then return ack(x - 1, 1) end
		return ack(x - 1, ack(x, y - 1))
	end
	function ackW(x, y)
		function rec(x, y)
			if x == 0 then return y + 1 end
			if y == 0 then return fw2(rec)(x - 1, 1) end
			return fw2(rec)(x - 1, fw2(rec)(x, y - 1))
		end
		return fw2(rec)(x, y)
	end

	function tarai(x, y, z)
		if x <= y then return y end
		return tarai(tarai(x-1, y, z), tarai(y-1, z, x), tarai(z-1, x, y))
	end
	function taraiW(x, y, z)
		function rec(x, y, z)
			if x <= y then return y end
			return fw3(rec)(
				fw3(rec)(x-1, y, z),
				fw3(rec)(y-1, z, x),
				fw3(rec)(z-1, x, y)
			)
		end
		return fw3(rec)(x, y, z)
	end

	local pAC1 = makePreds({isFun, isFun, isFun}, checkA)
	local pAC2 = makePreds({isTbl, isTbl, isTbl}, checkA)
	function fwC1(f) return wrapWithPreds(f, pAC1, pR, unpacker) end
	function fwC2A(f) return wrapWithPreds(f, pAC2, pR, unpacker) end
	function fwC2B(f) return wrapWithPreds(f, pEmpty, pR, unpacker) end

	function taraiC(x, y, z)
		function rec(x, y, z)
			if x() <= y() then return y() end
			return rec(
				function () return rec(function() return x() - 1 end, y, z) end,
				function () return rec(function() return y() - 1 end, z, x) end,
				function () return rec(function() return z() - 1 end, x, y) end
			)
		end
		return rec(
			function () return x end,
			function () return y end,
			function () return z end
		)
	end
	function taraiCW1(x, y, z)
		function rec(x, y, z)
			if x() <= y() then return y() end
			return fwC1(rec)(
				function() return fwC1(rec)(function() return x()-1 end, y, z) end,
				function() return fwC1(rec)(function() return y()-1 end, z, x) end,
				function() return fwC1(rec)(function() return z()-1 end, x, y) end
			)
		end
		return fwC1(rec)(
			function() return x end,
			function() return y end,
			function() return z end
		)
	end
	function taraiCW2(x, y, z)
		function rec(x, y, z)
			if x() <= y() then return y() end
			return fwC2A(rec)(
				fwC2B(function() return fwC2A(rec)(fwC2B(function() return x()-1 end), y, z) end),
				fwC2B(function() return fwC2A(rec)(fwC2B(function() return y()-1 end), z, x) end),
				fwC2B(function() return fwC2A(rec)(fwC2B(function() return z()-1 end), x, y) end)
			)
		end
		return fwC2A(rec)(
			fwC2B(function() return x end),
			fwC2B(function() return y end),
			fwC2B(function() return z end)
		)
	end

	unpacker:reset()
	print("ack(3, 3):", ack(3, 3), ackW(3, 3))
	print(count(ack, 3, 3), unpacker:get())

	unpacker:reset()
	print("tarai(10, 5, 0):", tarai(10, 5, 0), taraiW(10, 5, 0))
	print(count(tarai, 10, 5, 0), unpacker:get())

	unpacker:reset()
	print("taraiC(100, 50, 0):", taraiC(100, 50, 0), taraiCW1(100, 50, 0))
	print(count(taraiC, 100, 50, 0), unpacker:get())

	unpacker:reset()
	print("taraiC(100, 50, 0):", taraiC(100, 50, 0), taraiCW2(100, 50, 0))
	print(count(taraiC, 100, 50, 0), unpacker:get())
end
