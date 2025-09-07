local function abs(n) return n<0 and -n or n end

local function atLeastOne(n) return n>1 and n or 1 end

local d_sethook = debug.sethook

local function count(f, ...)
	local c = 0
	d_sethook(function() c = c + 1 end, "c")
	f(...)
	d_sethook()
	return c
end

local function decrement(x) return x - 1 end

local function id(x) return x end

local function increment(x) return x + 1 end

local function isBool(v)
	return type(v) == "boolean"
end

local function isFh(v)
	return io.type(v) == "file"
end

local function isFun(v)
	return type(v) == "function"
end

local function isNum(v)
	return type(v) == "number"
end

local function isStr(v)
	return type(v) == "string"
end

local function isTbl(v)
	return type(v) == "table"
end

local function isBoolOrNil(v)
	return type(v) == "boolean" or v == nil
end

local function isFhOrNil(v)
	return io.type(v) == "file" or v == nil
end

local function isNumOrNil(v)
	return type(v) == "number" or v == nil
end

local function assertInitialValue(width, height)
	assert(type(width) == "number", "'width' must be a number.")
	assert(type(height) == "number", "'height' must be a number.")
end

local d_getinfo = debug.getinfo

local function getNumOfParams(f)
	return d_getinfo(f).nparams
end

local function getValueOrNil(predicate, v)
	if predicate(v) then
		return v
	else
		return nil
	end
end

local function getValueOrInit(predicate, v, initialValue)
	if predicate(v) then
		return v
	else
		return initialValue
	end
end

local function mustBeBool(v)
	assert(type(v) == "boolean", "Must be a boolean.")
	return v
end

local function mustBeNum(v)
	assert(type(v) == "number", "Must be a number.")
	return v
end

local function mustBeStr(v)
	assert(type(v) == "string", "Must be a string.")
	return v
end

-- local function readOnlyTable(t)
--   ...
-- end
-- see: http://lua-users.org/wiki/ReadOnlyTables
--      https://www.lua.org/pil/13.4.5.html
--      (the last part of) https://www.lua.org/pil/13.3.html

--
--  tableWriter(x, y, w, f, vFmt)
--
--    x     =  { number, number, number[, "L"] }
--    y     =  { number, number, number }
--    w     =  { number, number }
--    f     =  { function, function, function }
--    vFmt  =  { string, string, string }
--
local function tableWriter(x, y, w, f, vFmt)
	function fmt(n, s, f)
		local t = ("%%%d%s"):format(n, s)
		return function (...) return t:format(f(...)) end
	end

	function count(l, r, step)
		local t=0 for _=l,r,step do t=t+1 end return t
	end

	local padding = (" "):rep(w[1] + 2)
	local border = ("-"):rep(w[2] * count(x[1],x[2],x[3]))

	local th = fmt(w[1], vFmt[1].." |", f[1])
	local tdH = fmt(w[2], vFmt[2], f[2])
	local tdB = fmt(w[2], vFmt[3], f[3])

	local isL = x[4] == "L"

	return function (fh)
		fh = isFh(fh) and fh or io.stdout

		-- header
		fh:write(padding)
		for i=x[1],x[2],x[3] do fh:write(tdH(i)) end
		fh:write("\n", padding, border, "\n")

		-- body
		for j=y[1],y[2],y[3] do
			fh:write(th(j))
			for i=x[1],isL and j or x[2],x[3] do fh:write(tdB(i, j)) end
			fh:write("\n")
		end
	end
end

local function with(path, mode, body)
	local fh = io.open(path, mode)
	local ret, err = pcall(body, fh)
	fh:close()
	assert(ret == true, err)
end

local function check(validators, target)
	for i,v in ipairs(validators) do
		assert(v(target[i]), i)
	end
end

local t_unpack = table.unpack ~= nil and table.unpack or unpack

local function wrapWithValidator(body, paramValidators, returnValidators, unpacker)
	unpacker = unpacker ~= nil and unpacker or t_unpack
	return setmetatable({ numOfParams = #paramValidators }, {
		__call = function (self, ...)
			local arg = {...}
			check(paramValidators, arg)

			local ret = {body(...)}
			check(returnValidators, ret)

			return unpacker(ret)
		end
	})
end

local function gUnpackerWithCounter(unpacker)
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

return {
	abs = abs,
	atLeastOne = atLeastOne,
	count = count,
	decrement = decrement,
	id = id,
	increment = increment,
	isBool = isBool,
	isFh = isFh,
	isFun = isFun,
	isNum = isNum,
	isStr = isStr,
	isTbl = isTbl,
	isBoolOrNil = isBoolOrNil,
	isFhOrNil = isFhOrNil,
	isNumOrNil = isNumOrNil,
	assertInitialValue = assertInitialValue,
	getNumOfParams = getNumOfParams,
	getValueOrInit = getValueOrInit,
	mustBeBool = mustBeBool,
	mustBeNum = mustBeNum,
	mustBeStr = mustBeStr,
	tableWriter = tableWriter,
	with = with,
	wrapWithValidator = wrapWithValidator,
	gUnpackerWithCounter = gUnpackerWithCounter
}
