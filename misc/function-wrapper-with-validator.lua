--
--	function-wrapper-with-validator.lua
--
--	> lua[jit] function-wrapper-with-validator.lua
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
-- the result properly, depending on the version of Lua. Therefore, in such
-- cases, please pass your own 'unpacker' as an argument.
-- (see w4A and w4B below)
--

do
	function isBool(v) return type(v) == "boolean" end
	function isFh(v) return io.type(v) == "file" end
	function isFun(v) return type(v) == "function" end
	function isNum(v) return type(v) == "number" end
	function isStr(v) return type(v) == "string" end
	function isTbl(v) return type(v) == "table" end
	function isNumOrNil(v) return isNum(v) or v == nil end
	function isNumAndNonNeg(v) return isNum(v) and v >= 0 end

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

	local unpackerWithCounter = (function ()
		local T = { c = 0 }
		function T:get() return T.c end
		function T:reset() T.c = 0 end
		return setmetatable(T, {
			__call = function (self, r)
				T.c = T.c + 1
				return r[1]
			end
		})
	end)()

	function fw1(f)
		return wrapWithValidator(
			f, {isNum}, {isNum}, unpackerWithCounter
		)
	end
	function fw2(f)
		return wrapWithValidator(
			f, {isNum, isNum}, {isNum}, unpackerWithCounter
		)
	end

	function fac1(n)
		if n > 0 then return n * fw1(fac1)(n - 1) else return 1 end
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

	assert(
		3628800 == fw1(fac1)(10)
		and 11 == unpackerWithCounter:get() -- 11: 10...0
	)
	unpackerWithCounter:reset()
	assert(
		3628800 == fac2(10)
		and 11 == unpackerWithCounter:get() -- 11: 10...0
	)

	print("^-- ok / raise an error --v")

	local ret, err = pcall(w1, 1, 2, {})
	assert(ret, err)
end

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

-- do
-- 	...
--
-- 	local vEmpty = makeValidator({})
-- 	local vFh = makeValidator({isFh})
-- 	local vNum = makeValidator({isNum})
-- 	local vNumStrTbl = makeValidator({isNum, isStr, isTbl})
-- 	local vBool2 = makeValidator({isBool, isBool})
--
-- 	local w1 = wrapWithValidator(f1, vNumStrTbl, vNum)
-- 	local w2 = wrapWithValidator(f2, vEmpty, vBool2)
-- 	local w3 = wrapWithValidator(f3, vFh, vEmpty)
--
-- 	print(w1(os.clock(), "1", {2}))
-- 	print(w2())
-- 	print(w3(io.stdout))
--
-- 	...
-- end
