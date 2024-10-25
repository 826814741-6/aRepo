--
--	function-wrapper-with-validator.lua
--
--	> lua[jit] function-wrapper-with-validator.lua
--

local t_unpack = table.unpack ~= nil and table.unpack or unpack

function check(target, validators)
	for i,v in ipairs(target) do
		assert(validators[i](v), i)
	end
end

function wrapWithValidator(body, paramValidators, returnValidators)
	return setmetatable({}, {
		__call = function (self, ...)
			local arg = {...}
			check(arg, paramValidators)

			local ret = {body(...)}
			check(ret, returnValidators)

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

	function f1(n, s, t) return n end
	function f2() return true, false end
	function f3(fh) end
	function f4(n) return function (x, y) return "valid?" end end

	local w1 = wrapWithValidator(f1, {isNum, isStr, isTbl}, {isNum})
	local w2 = wrapWithValidator(f2, {}, {isBool, isBool})
	local w3 = wrapWithValidator(f3, {isFh}, {})
	local w4 = wrapWithValidator(f4, {isNum}, {isFun})
	local w5 = wrapWithValidator(w4(0), {isNum, isNum}, {isStr})

	print(w1(os.clock(), "1", {2}))
	print(w2())
	print(w3(io.stdout))
	print(w4(0))
	print(w5(1, 2))

	print("^-- ok / raise an error --v")

	local ret, err = pcall(w1, 1, 2, {})
	assert(ret, err)
end
