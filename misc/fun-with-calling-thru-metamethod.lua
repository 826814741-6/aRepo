--
--  fun-with-calling-thru-metamethod.lua
--
--  > lua[jit] fun-with-calling-thru-metamethod.lua
--

local t_unpack = table.unpack ~= nil and table.unpack or unpack

function check(validators, target)
	for i,v in ipairs(validators) do
		assert(v(target[i]), i)
	end
end

function wrapWithValidator(body, paramValidators, returnValidators, unpacker)
	unpacker = unpacker ~= nil and unpacker or t_unpack
	return setmetatable({}, {
		__call = function (self, ...)
			local arg = {...}
			check(paramValidators, arg)

			local ret = {body(...)}
			check(returnValidators, ret)

			return unpacker(ret)
		end
	})
end
--
-- Note:
-- If the return value contains nil, 't_unpack' may not be able to retrieve
-- the result properly depending on your build of Lua/LuaJIT. In this case,
-- please pass your own 'unpacker' as an argument.
-- (see w4A and w4B below)
--

function isBool(v) return type(v) == "boolean" end
function isFh(v) return io.type(v) == "file" end
function isFun(v) return type(v) == "function" end
function isNum(v) return type(v) == "number" end
function isStr(v) return type(v) == "string" end
function isTbl(v) return type(v) == "table" end
function isNumOrNil(v) return isNum(v) or v == nil end
function isNumAndNonNeg(v) return isNum(v) and v >= 0 end

do
	function f1(n, s, t) return n end
	function f2() return true, false end
	function f3(fh) end
	function f4(n) return 0, nil, 1 end
	function f5(n) return n < 0 and -n or n end
	function f6(n) return function (x, y) return "valid?" end end

	local w1 = wrapWithValidator(f1, {isNum, isStr, isTbl}, {isNum})
	local w2 = wrapWithValidator(f2, {}, {isBool, isBool})
	local w3 = wrapWithValidator(f3, {isFh}, {})
	local w4A = wrapWithValidator(
		f4,
		{isNumOrNil},
		{isNumOrNil, isNumOrNil, isNumOrNil}
	)
	local w4B = wrapWithValidator(
		f4,
		{isNumOrNil},
		{isNumOrNil, isNumOrNil, isNumOrNil},
		function (r) return r[1], r[2], r[3] end
	)
	local w5 = wrapWithValidator(f5, {isNum}, {isNumAndNonNeg})
	local w6 = wrapWithValidator(f6, {isNum}, {isFun})
	local w7 = wrapWithValidator(w6(0), {isNum, isNum}, {isStr})

	print(w1(os.clock(), "1", {2}))
	print(w2())
	print(w3(io.stdout))
	print("t_unpack:", w4A())
	print("user unpacker:", w4B())
	print(w5(-1), w5(-0.1), w5(0), w5(0.1), w5(1))
	print(w6(0))
	print(w7(1, 2))

	print("^-- ok / raise an error --v")

	local ret, err = pcall(w1, 1, 2, {})
	assert(ret, err)  -- Please comment out this line,
end                       -- if you want to see the results of the latter half.

--
-- If you want to use a different checker instead of the function 'check'
-- above, or if you want to use a different checker for each validator in
-- param and return, the following approach might suit you:
--

function makeValidator(validators, checker)
	local T = { validators = validators }

	T.check = checker ~= nil
		and checker
		or function (self, target)
			for i,v in ipairs(self.validators) do
				assert(v(target[i]), i)
			end
		end

	return T
end

function wrapWithValidator(body, paramValidator, returnValidator, unpacker)
	unpacker = unpacker ~= nil and unpacker or t_unpack
	return setmetatable({}, {
		__call = function (self, ...)
			local arg = {...}
			paramValidator:check(arg)

			local ret = {body(...)}
			returnValidator:check(ret)

			return unpacker(ret)
		end
	})
end

local i_write = io.write

function gCheckVerbose(header)
	return function (self, target)
		i_write(header, "(", os.clock(), ") ")
		for i,v in ipairs(self.validators) do
			i_write(" ", i, ":", tostring(target[i]))
			assert(v(target[i]), i)
		end
		i_write("\n")
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
	--
	-- If you want to see the results below, please comment out the 'assert'
	-- line above (line number: 84).
	--

	local checkP, checkR = gCheckVerbose("[param]"), gCheckVerbose("[return]")
	local unpacker = gUnpackerWithCounter()

	local vP1 = makeValidator({isNum}, checkP)
	local vP2 = makeValidator({isNum, isNum}, checkP)
	local vP3 = makeValidator({isNum, isNum, isNum}, checkP)
	local vP4 = makeValidator({isNum, isFun}, checkP)
	local vP5 = makeValidator({isNum, isTbl}, checkP)
	local vR = makeValidator({isNum}, checkR)
	local vEmpty = makeValidator({})

	function fw1(f) return wrapWithValidator(f, vP1, vR, unpacker) end
	function fw2(f) return wrapWithValidator(f, vP2, vR, unpacker) end
	function fw3(f) return wrapWithValidator(f, vP3, vR, unpacker) end
	function fw4(f) return wrapWithValidator(f, vP4, vEmpty, unpacker) end
	function fw5A(f) return wrapWithValidator(f, vP5, vEmpty, unpacker) end
	function fw5B(f) return wrapWithValidator(f, vP1, vEmpty, unpacker) end

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

	local vPC = makeValidator({isFun, isFun, isFun})
	function fwC(f) return wrapWithValidator(f, vPC, vR, unpacker) end

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

	unpacker:reset()
	print("ack(3, 3):", ack(3, 3), ackW(3, 3))
	print(count(ack, 3, 3), unpacker:get())

	unpacker:reset()
	print("tarai(10, 5, 0):", tarai(10, 5, 0), taraiW(10, 5, 0))
	print(count(tarai, 10, 5, 0), unpacker:get())

	unpacker:reset()
	print("taraiC(100, 50, 0):", taraiC(100, 50, 0), taraiCW(100, 50, 0))
	print(count(taraiC, 100, 50, 0), unpacker:get())
end
