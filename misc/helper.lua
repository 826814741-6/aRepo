--
--  helper.lua: some helper functions for toy scripts
--

local t_insert, t_remove = table.insert, table.remove
local t_unpack = table.unpack ~= nil and table.unpack or unpack

local function aintNil(v, defaultValue)
	assert(defaultValue ~= nil, "'defaultValue' must be a non-nil value.")
	return v ~= nil and v or defaultValue
end

local function alwaysFalse(_) return false end
local function alwaysNil(_) return nil end
local function alwaysTrue(_) return true end

local function recA(a, b)
	for k,v in pairs(a) do
		if type(v) == "table" then
			recA(v, b[k])
		else
			assert(v == b[k])
		end
	end
end

local function assertA(a, b, ...)
	assert(type(a) == "table" and type(b) == "table")
	recA(a, b)
	recA(b, a)
	local rest = ...
	if rest ~= nil then
		assertA(b, ...)
	end
end

local function beCircular(f, ...)
	local t = {}
	for i,v in ipairs({...}) do
		t[i] = { v = f(v), next = i + 1 }
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

local function lenT(v)
	local r = 0
	for _ in pairs(v) do
		r = r + 1
	end
	return r
end
-- cf. The Length Operator
-- https://www.lua.org/manual/5.4/manual.html#3.4.7
-- https://www.lua.org/manual/5.1/manual.html#2.5.5

local function B_get(self) return self.buf end
local function B_len(self) return lenT(self.buf) end
local function B_lenViaOp(self) return #self.buf end
local function B_pop(self) return t_remove(self.buf) end
local function B_popHead(self) return t_remove(self.buf, 1) end
local function B_push(self, v) return t_insert(self.buf, v) end
local function B_pushHead(self, v) return t_insert(self.buf, v, 1) end
local function B_reset(self) self.buf = {} end
--
-- table.insert/table.remove and position shifting up/down:
-- https://www.lua.org/manual/5.4/manual.html#pdf-table.insert
-- https://www.lua.org/manual/5.4/manual.html#pdf-table.remove
-- https://www.lua.org/manual/5.1/manual.html#pdf-table.insert
-- https://www.lua.org/manual/5.1/manual.html#pdf-table.remove
--

local function B_iter(self)
	local i = 1
	return function ()
		local r = self.buf[i]
		i = i + 1
		return r
	end
end

local function makeBuffer()
	local T = { buf = {} }

	setmetatable(T, { __len = B_lenViaOp }) -- v5.2+/+LUA52COMPAT

	T.get, T.iter, T.len, T.lenViaOp, T.pop, T.popHead, T.push, T.pushHead, T.reset =
		B_get, B_iter, B_len, B_lenViaOp, B_pop, B_popHead, B_push, B_pushHead, B_reset

	return T
end
--
-- >> A program can modify the behavior of the length operator for
-- >> any value but strings through the __len metamethod (see 2.4).
-- >> -- https://www.lua.org/manual/5.2/manual.html#3.4.6
--
-- the "len" part in the "Metatables" sec of v5.2/v5.1 manual:
--   https://www.lua.org/manual/5.2/manual.html#2.4
--   https://www.lua.org/manual/5.1/manual.html#2.8
-- and "LUAJIT_ENABLE_LUA52COMPAT" in:
--   https://luajit.org/extensions.html
--   (cf. LJ_52,lj_meta_len (in src/{lj_arch.h,...,lj_meta.c,...}))
--

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
	assertA = assertA,
	beCircular = beCircular,
	bePrintablePair = bePrintablePair,
	flattenOnce = flattenOnce,
	id = id,
	makeBuffer = makeBuffer,
	mustBeNonNil = mustBeNonNil,
	unpackerL = unpackerL,
	unpackerR = unpackerR
}
