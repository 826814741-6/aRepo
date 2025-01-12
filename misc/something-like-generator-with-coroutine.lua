--
--	something-like-generator-with-coroutine.lua
--
--	> lua[jit] something-like-generator-with-coroutine.lua
--

local co_create = coroutine.create
local co_resume = coroutine.resume
local co_yield = coroutine.yield
local t_insert = table.insert
local t_unpack = table.unpack ~= nil and table.unpack or unpack

function coGen(fn, ...)
	local T = { co = fn(...) }

	function T:drop(n)
		n = n ~= nil and n or 0

		for _=1,n do
			co_resume(T.co)
		end
		return T, {}
	end

	-- something-like-take
	function T:take(n, f)
		n = n ~= nil and n or 0
		f = f ~= nil and f or function (e) return e end

		local r = {}
		for i=1,n do
			local _, v = co_resume(T.co)
			r[i] = f(v)
		end
		return T, r
	end

	-- something-like-filter
	function T:filter(n, f, g)
		n = n ~= nil and n or 0
		f = f ~= nil and f or function (...) return true end
		g = g ~= nil and g or function (e) return e end

		local r, i = {}, 1
		while i <= n do
			local _, v = co_resume(T.co)
			if f(i, v) then r[i], i = g(v), i + 1 end
		end
		return T, r
	end

	return T
end

function makeBuffer()
	local T = { buf = {} }

	function T:insert(r)
		t_insert(T.buf, r)
	end

	function T:get()
		return T.buf
	end

	function T:reset()
		T.buf = {}
	end

	return T
end

--

-- 0, 1, 2, 3, 4, ...
function iota(start, step)
	start = start ~= nil and start or 0
	step = step ~= nil and step or 1

	return co_create(function ()
		local n = start
		while true do
			co_yield(n)
			n = n + step
		end
	end)
end

-- 0, 1, 1, 2, 3, ...
function fib(zero, one)
	zero = zero ~= nil and zero or 0
	one = one ~= nil and one or 1

	return co_create(function ()
		local a, b = zero, one
		while true do
			co_yield(a)
			a, b = b, a + b
		end
	end)
end

-- {0, 1}, {1, 1}, {1, 2}, {2, 3}, ...
function fibPair(zero, one)
	zero = zero ~= nil and zero or 0
	one = one ~= nil and one or 1

	function bePrintable(a, b)
		return setmetatable({a, b}, {
			__tostring = function (t)
				return ("%s, %s"):format(t[1], t[2])
			end
		})
	end

	return co_create(function ()
		local a, b = zero, one
		while true do
			co_yield(bePrintable(a, b))
			a, b = b, a + b
		end
	end)
end

-- 1, 2, 6, 24, 120, ...
function fac(one)
	one = one ~= nil and one or 1

	return co_create(function ()
		local n, acc = one, one
		while true do
			n, acc = n + one, acc * n
			co_yield(acc)
		end
	end)
end

function beCircular(...)
	local t = {}
	for i,v in ipairs({...}) do
		t[i] = { v = v, next = i + 1 }
	end
	t[#t].next = 1
	return t
end

function getSomethingCircular(...)
	local t = beCircular(...)
	local i = 1
	return co_create(function ()
		while true do
			co_yield(t[i].v)
			i = t[i].next
		end
	end)
end

-- Sun, Mon, Tue, Wed, ...
function daysOfTheWeek()
	return getSomethingCircular(
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
	)
end
--
-- -- Jan, Feb, Mar, Apr, ...
-- function monthsOfTheYear()
-- 	return getSomethingCircular(
-- 		"Jan", "Feb", "Mar", "Apr", "May", "Jun",
-- 		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
-- 	)
-- end

-- 0, 1, 2, 0, 1, 2, ...
function remaindersDividedBy3()
	return getSomethingCircular(0, 1, 2)
end

--

-- something-like-flatten-once
function flattenOnce(aTable)
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

function p(first, second)
	print(t_unpack(second ~= nil and second or flattenOnce(first)))
end

--

function _unwrap(...)
	return t_unpack(select(2, ...))
end

function dropCycle(n, ...)
	for _,v in ipairs({...}) do
		v:drop(n)
	end
end

function drop(n, ...)
	local t = beCircular(...)

	local i, j = 1, 1
	while i <= n do
		t[j].v:drop(1)
		i, j = i + 1, t[j].next
	end
end

function takeCycle(n, ...)
	local r = {}
	for i=1,n do
		local t = {}
		for j,v in ipairs({...}) do
			t[j] = _unwrap(v:take(1))
		end
		r[i] = t
	end
	return r
end

function take(n, ...)
	local t = beCircular(...)

	local r, i, j = {}, 1, 1
	while i <= n do
		r[i], i, j = _unwrap(t[j].v:take(1)), i + 1, t[j].next
	end
	return r
end

--

do
	p(coGen(iota):take(10))
	p(coGen(iota, 50, -1):drop(50):take(10))
	p(coGen(iota):take(10, function (v) return v*v*v end))
	p(coGen(iota):filter(10, function (_,v) return v%2==0 end))

	print("--")

	local buf = makeBuffer()

	p(coGen(iota):drop(3):take(3)) -- 3, 4, 5
	p(coGen(iota):drop(3):take(3, function (v) buf:insert(v) end)) -- (nothing)
	p(coGen(iota):drop(3):take(3, function (v) buf:insert(v) return v end)) -- 3, 4, 5
	p(buf:get()) -- 3, 4, 5, 3, 4, 5

	buf:reset()

	coGen(iota)
		:drop(5) -- 0, 1, 2, 3, 4
		:filter(
			5,
			function (_, v) return v % 2 == 0 end,
			function (v) buf:insert(v) end
		)        -- 6, 8, 10, 12, 14
		:drop(3) -- 15, 16, 17
		:filter(
			5,
			function (_, v) return v % 3 == 0 end,
			function (v) buf:insert(v) end
		)        -- 18, 21, 24, 27, 30
	p(buf:get())

	print("--")

	local hasBC, bc = pcall(require, 'bc')

	local coA = coGen(fib)
	local coB = hasBC and coGen(fibPair, bc.new(0), bc.new(1)) or coGen(fibPair)
	local coC = coGen(fac, hasBC and bc.new(1) or 1)
	local coD = coGen(daysOfTheWeek)
	local coE = coGen(remaindersDividedBy3)

	p(coA:take(5))
	p(coA:take(5))
	p(coA:drop(30):take(1))

	p(coB:take(5))
	p(coB:take(5))
	p(coB:drop(300):take(1))

	p(coC:take(5))
	p(coC:take(5))
	p(coC:drop(89):take(1))

	p(coD:take(5))
	p(coD:take(5))
	p(coD:drop(53):take(7))

	p(coE:take(5))
	p(coE:take(5))
	p(coE:drop(50):take(9))

	print("--")

	local a, b, c = coGen(iota), coGen(iota, -5), coGen(iota, 100, -1)

	p(takeCycle(3, a, b, c))
	dropCycle(3, a, b, c)
	p(takeCycle(3, a, b, c))

	a, b, c = coGen(iota), coGen(iota, -5), coGen(iota, 100, -1)

	p(take(9, a, b, c))
	drop(7, a, b, c) b:drop(1) c:drop(1)
	p(take(9, a, b, c))
end
