--
--	something-like-generator-with-closure.lua
--
--	> lua[jit] something-like-generator-with-closure.lua
--

local t_insert = table.insert
local t_unpack = table.unpack ~= nil and table.unpack or unpack

function clGen(fn, ...)
	local T = { cl = fn(...) }

	function T:drop(n)
		n = n ~= nil and n or 0

		for _=1,n do
			T.cl()
		end
		return T, {}
	end

	-- something-like-take
	function T:take(n, f)
		n = n ~= nil and n or 0
		f = f ~= nil and f or function (e) return e end

		local r = {}
		for i=1,n do
			r[i] = f(T.cl())
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
			local v = T.cl()
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

	local n = start - step
	return function ()
		n = n + step
		return n
	end
end

-- 0, 1, 1, 2, 3, ...
function fib(zero, one)
	zero = zero ~= nil and zero or 0
	one = one ~= nil and one or 1

	local a, b = one, zero
	return function ()
		a, b = b, a + b
		return a
	end
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

	local a, b = one, zero
	return function ()
		a, b = b, a + b
		return bePrintable(a, b)
	end
end

-- 1, 2, 6, 24, 120, ...
function fac(one)
	one = one ~= nil and one or 1

	local n, acc = one, one
	return function ()
		n, acc = n + one, acc * n
		return acc
	end
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
	local i = #t
	return function ()
		i = t[i].next
		return t[i].v
	end
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
	p(clGen(iota):take(10))
	p(clGen(iota, 50, -1):drop(50):take(10))
	p(clGen(iota):take(10, function (v) return v*v*v end))
	p(clGen(iota):filter(10, function (_,v) if v%2==0 then return v end end))

	print("--")

	local buf = makeBuffer()

	p(clGen(iota):drop(3):take(3)) -- 3, 4, 5
	p(clGen(iota):drop(3):take(3, function (v) buf:insert(v) end)) -- (nothing)
	p(clGen(iota):drop(3):take(3, function (v) buf:insert(v) return v end)) -- 3, 4, 5
	p(buf:get()) -- 3, 4, 5, 3, 4, 5

	buf:reset()

	clGen(iota)
		:drop(5) -- 0, 1, 2, 3, 4
		:filter(
			5,
			function (_,v) if v%2==0 then return v end end,
			function (v) buf:insert(v) end
		)        -- 6, 8, 10, 12, 14
		:drop(3) -- 15, 16, 17
		:filter(
			5,
			function (_,v) if v%3==0 then return v end end,
			function (v) buf:insert(v) end
		)        -- 18, 21, 24, 27, 30
	p(buf:get())

	print("--")

	local hasBC, bc = pcall(require, 'bc')

	local clA = clGen(fib)
	local clB = hasBC and clGen(fibPair, bc.new(0), bc.new(1)) or clGen(fibPair)
	local clC = clGen(fac, hasBC and bc.new(1) or 1)
	local clD = clGen(daysOfTheWeek)
	local clE = clGen(remaindersDividedBy3)

	p(clA:take(5))
	p(clA:take(5))
	p(clA:drop(30):take(1))

	p(clB:take(5))
	p(clB:take(5))
	p(clB:drop(300):take(1))

	p(clC:take(5))
	p(clC:take(5))
	p(clC:drop(89):take(1))

	p(clD:take(5))
	p(clD:take(5))
	p(clD:drop(53):take(7))

	p(clE:take(5))
	p(clE:take(5))
	p(clE:drop(50):take(9))

	print("--")

	local a, b, c = clGen(iota), clGen(iota, -5), clGen(iota, 100, -1)

	p(takeCycle(3, a, b, c))
	dropCycle(3, a, b, c)
	p(takeCycle(3, a, b, c))

	a, b, c = clGen(iota), clGen(iota, -5), clGen(iota, 100, -1)

	p(take(9, a, b, c))
	drop(7, a, b, c) b:drop(1) c:drop(1)
	p(take(9, a, b, c))
end
