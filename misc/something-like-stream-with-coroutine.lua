--
--	something-like-stream-with-coroutine.lua
--
--	> lua[jit] something-like-stream-with-coroutine.lua
--

local co_create = coroutine.create
local co_resume = coroutine.resume
local co_yield = coroutine.yield
local t_insert = table.insert
local t_unpack = table.unpack ~= nil and table.unpack or unpack

function coStream(co, ...)
	local T = { co = co(...) }

	function T:skip(n)
		n = n ~= nil and n or 0

		for _=1,n do
			co_resume(T.co)
		end
		return T, {}
	end

	-- something-like-take
	function T:take(n)
		n = n ~= nil and n or 0

		local r = {}
		for i=1,n do
			local _, v = co_resume(T.co)
			r[i] = v
		end
		return T, r
	end

	-- something-like-map
	function T:map(n, f)
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
	function T:filter(n, f)
		n = n ~= nil and n or 0
		f = f ~= nil and f or function (...) return true end

		local r, i = {}, 1
		while i <= n do
			local _, v = co_resume(T.co)
			if f(i, v) then r[i], i = v, i + 1 end
		end
		return T, r
	end

	return T
end

function extendsWithBufferMethods(T)
	function T:takeB(buffer, n)
		local t, r = T:take(n)
		buffer:insert(r)
		return t, r
	end

	function T:mapB(buffer, n, f)
		local t, r = T:map(n, f)
		buffer:insert(r)
		return t, r
	end

	function T:filterB(buffer, n, f)
		local t, r = T:filter(n, f)
		buffer:insert(r)
		return t, r
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
function seq(start, step)
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

function _init(...)
	local t = {}
	for i,v in ipairs({...}) do
		t[i] = { v = v, next = i + 1 }
	end
	t[#t].next = 1
	return t
end

function _unwrap(...)
	return t_unpack(select(2, ...))
end

function skipStep(n, ...)
	for _,v in ipairs({...}) do
		v:skip(n)
	end
end

function skip(n, ...)
	local t = _init(...)

	local i, j = 1, 1
	while i <= n do
		t[j].v:skip(1)
		i, j = i + 1, t[j].next
	end
end

function takeStep(n, ...)
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
	local t = _init(...)

	local r, i, j = {}, 1, 1
	while i <= n do
		r[i], i, j = _unwrap(t[j].v:take(1)), i + 1, t[j].next
	end
	return r
end

--

do
	p(coStream(seq):take(10))
	p(coStream(seq):skip(50):take(10))
	p(coStream(seq):map(10, function (v) return v*v*v end))
	p(coStream(seq):filter(10, function (_,v) if v%2==0 then return v end end))

	print("--")

	local co = coStream(seq)
	p(co:skip(5):take(5):skip(5):take(5))

	local buf = makeBuffer()
	co = extendsWithBufferMethods(coStream(seq))
	co:skip(5):takeB(buf,5):skip(5):takeB(buf,5)
	p(buf:get())

	buf:reset()
	co = extendsWithBufferMethods(coStream(seq))
	co:skip(5):takeB(buf,5):skip(5):take(5):skip(5):takeB(buf,5)
	p(buf:get())

	print("--")

	local hasBC, bc = pcall(require, 'bc')

	local coA = coStream(fib)
	local coB = hasBC and coStream(fibPair, bc.new(0), bc.new(1)) or coStream(fibPair)
	local coC = coStream(fac, hasBC and bc.new(1) or 1)

	p(coA:take(5))
	p(coA:take(5))
	p(coA:skip(30):take(1))

	p(coB:take(5))
	p(coB:take(5))
	p(coB:skip(300):take(1))

	p(coC:take(5))
	p(coC:take(5))
	p(coC:skip(89):take(1))

	print("--")

	local a, b, c = coStream(seq), coStream(seq, -5), coStream(seq, 100, -1)

	p(takeStep(3, a, b, c))
	skipStep(3, a, b, c)
	p(takeStep(3, a, b, c))

	a, b, c = coStream(seq), coStream(seq, -5), coStream(seq, 100, -1)

	p(take(9, a, b, c))
	skip(7, a, b, c) b:skip(1) c:skip(1)
	p(take(9, a, b, c))
end
