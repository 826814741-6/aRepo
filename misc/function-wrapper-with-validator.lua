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

function wrapWithValidator(body, paramValidators, returnValidators)
	return setmetatable({}, {
		__call = function (self, ...)
			local arg = {...}
			check(paramValidators, arg)

			local ret = {body(...)}
			check(returnValidators, ret)

			return t_unpack(ret)
		end
	})
end

do
	function isBool(v) return type(v) == "boolean" end
	function isFh(v) return io.type(v) == "file" end
	function isFun(v) return type(v) == "function" end
	function isNum(v) return type(v) == "number" end
	function isStr(v) return type(v) == "string" end
	function isTbl(v) return type(v) == "table" end
	function isNumOrNil(v) return isNum(v) or v == nil end

	function f1(n, s, t) return n end
	function f2() return true, false end
	function f3(fh) end
	function f4(n) return 0 end
	function f5(n) return function (x, y) return "valid?" end end

	local w1 = wrapWithValidator(f1, {isNum, isStr, isTbl}, {isNum})
	local w2 = wrapWithValidator(f2, {}, {isBool, isBool})
	local w3 = wrapWithValidator(f3, {isFh}, {})
	local w4 = wrapWithValidator(f4, {isNumOrNil}, {isNumOrNil})
	local w5 = wrapWithValidator(f5, {isNum}, {isFun})
	local w6 = wrapWithValidator(w5(0), {isNum, isNum}, {isStr})

	print(w1(os.clock(), "1", {2}))
	print(w2())
	print(w3(io.stdout))
	print(w4())
	print(w5(0))
	print(w6(1, 2))

	print("^-- ok / raise an error --v")

	local ret, err = pcall(w1, 1, 2, {})
	assert(ret, err)
end
