--
--	helper.lua: some helper functions for toy scripts
--

local t_insert = table.insert
local t_unpack = table.unpack ~= nil and table.unpack or unpack

local function aintNil(v, defaultValue)
	assert(defaultValue ~= nil, "'defaultValue' must be a non-nil value.")
	return v ~= nil and v or defaultValue
end

local function alwaysFalse(_) return false end
local function alwaysNil(_) return nil end
local function alwaysTrue(_) return true end

local function beCircular(...)
	local t = {}
	for i,v in ipairs({...}) do
		t[i] = { v = v, next = i + 1 }
	end
	t[#t].next = 1
	return t
end

local function bePrintablePair(l, r)
	return setmetatable({l, r}, {
		__tostring = function (t)
			return ("%s, %s"):format(t[1], t[2])
		end
	})
end

local function flattenOnce(aTable)
	--
	-- Please assume that aTable is a table:
	-- {[1]={...},[2]={...},...,[(sequential)]={...} or {} or v,...,[#t]={...}}
	--
	local r = {}
	for _,v1 in ipairs(aTable) do
		if type(v1) == "table" then
			-- {...}
			for _,v2 in ipairs(v1) do
				t_insert(r, v2)
			end
			-- {}
			if #v1 == 0 then
				t_insert(r, "__EMPTY__")
			end
		else
			-- v
			t_insert(r, v1)
		end
	end
	return r
end
--
-- If you want to flatten a deeply-nested-table thoroughly,
-- please see:
-- - (the last part of) http://lua-users.org/wiki/CurriedLua
-- - https://stackoverflow.com/questions/67539008/lua-unpack-all-the-hierarchy-of-a-nested-table-and-store-and-return-table-with
--     and
-- - https://stackoverflow.com/questions/55108794/what-is-the-difference-between-pairs-and-ipairs-in-lua
-- - ...
--

local function id(v) return v end

local function makeBuffer()
	local T = { buf = {} }

	function T:insert(r) t_insert(T.buf, r) end
	function T:get() return T.buf end
	function T:reset() T.buf = {} end

	return T
end

local function mustBeNonNil(v)
	assert(v ~= nil)
	return v
end

local function unpackerL(l, _) return t_unpack(l) end
local function unpackerR(_, r) return t_unpack(r) end

return {
	aintNil = aintNil,
	alwaysFalse = alwaysFalse,
	alwaysNil = alwaysNil,
	alwaysTrue = alwaysTrue,
	beCircular = beCircular,
	bePrintablePair = bePrintablePair,
	flattenOnce = flattenOnce,
	id = id,
	makeBuffer = makeBuffer,
	mustBeNonNil = mustBeNonNil,
	unpackerL = unpackerL,
	unpackerR = unpackerR
}
