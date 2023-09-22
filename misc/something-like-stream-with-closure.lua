--
--	something-like-stream-with-closure.lua
--
--	> lua[jit] something-like-stream-with-closure.lua
--

local t_insert = table.insert
local t_unpack = table.unpack ~= nil and table.unpack or unpack

function clStream(f, ...)
	local T = { f = f(...) }

	function T:skip(n)
		n = n ~= nil and n or 0

		for _=1,n do
			T.f()
		end
		return T, {}
	end

	-- something-like-take
	function T:take(n)
		n = n ~= nil and n or 0

		local r = {}
		for i=1,n do
			r[i] = T.f()
		end
		return T, r
	end

	-- something-like-map
	function T:map(n, f)
		n = n ~= nil and n or 0
		f = f ~= nil and f or function (e) return e end

		local r = {}
		for i=1,n do
			r[i] = f(T.f())
		end
		return T, r
	end

	-- something-like-filter
	function T:filter(n, f)
		n = n ~= nil and n or 0
		f = f ~= nil and f or function (...) return true end

		local r, i = {}, 1
		repeat
			local v = T.f()
			if f(i, v) then r[i], i = v, i + 1 end
		until i > n
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

-- 1, 2, 6, 24, 120, ...
function fac(one)
	one = one ~= nil and one or 1

	local n, acc = one, one
	return function ()
		n, acc = n + one, acc * n
		return acc
	end
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

do
	function p(...)
		local a, b = ...
		print(t_unpack(b ~= nil and b or flattenOnce(a:get())))
	end

	p(clStream(seq):take(10))
	p(clStream(seq):skip(50):take(10))
	p(clStream(seq):map(10, function (v) return v*v*v end))
	p(clStream(seq):filter(10, function (_,v) if v%2==0 then return v end end))

	print("--")

	local cl = clStream(seq)
	p(cl:skip(5):take(5):skip(5):take(5))

	local buf = makeBuffer()
	cl = extendsWithBufferMethods(clStream(seq))
	cl:skip(5):takeB(buf,5):skip(5):takeB(buf,5)
	p(buf)

	buf:reset()
	cl = extendsWithBufferMethods(clStream(seq))
	cl:skip(5):takeB(buf,5):skip(5):take(5):skip(5):takeB(buf,5)
	p(buf)

	print("--")

	local hasBC, bc = pcall(require, 'bc')

	local clA = clStream(fib)
	local clB = clStream(fac, hasBC and bc.new(1) or 1)

	p(clA:take(5))
	p(clA:take(5))
	p(clA:skip(30):take(1))

	p(clB:take(5))
	p(clB:take(5))
	p(clB:skip(89):take(1))
end
