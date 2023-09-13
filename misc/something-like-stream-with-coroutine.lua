--
--	something-like-stream-with-coroutine.lua
--
--	> lua[jit] something-like-stream-with-coroutine.lua
--	...
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
		repeat
			local _, v = co_resume(T.co)
			if f(i, v) then r[i], i = v, i + 1 end
		until i > n
		return T, r
	end

	return T
end

function extendsWithBufferMethods(obj)
	function obj:takeB(buffer, n)
		local t, r = obj:take(n)
		buffer:insert(r)
		return t, r
	end

	function obj:mapB(buffer, n, f)
		local t, r = obj:map(n, f)
		buffer:insert(r)
		return t, r
	end

	function obj:filterB(buffer, n, f)
		local t, r = obj:filter(n, f)
		buffer:insert(r)
		return t, r
	end

	return obj
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
function seq(zero, one)
	zero = zero ~= nil and zero or 0
	one = one ~= nil and one or 1

	return co_create(function ()
		local i = zero
		while true do
			co_yield(i)
			i = i + one
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

--v
function flatten(t)
	local r = {}
	for _,v1 in ipairs(t) do
		if type(v1) == 'table' then
			for _,v2 in ipairs(flatten(v1)) do
				t_insert(r, v2)
			end
		else
			t_insert(r, v1)
		end
	end
	return r
end
--^ from the last part of this article: http://lua-users.org/wiki/CurriedLua

do
	function p(...)
		local a, b = ...
		print(t_unpack(b ~= nil and b or flatten(a:get())))
	end

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
	p(buf)

	buf:reset()
	co = extendsWithBufferMethods(coStream(seq))
	co:skip(5):takeB(buf,5):skip(5):take(5):skip(5):takeB(buf,5)
	p(buf)

	print("--")

	local hasBC, bc = pcall(require, 'bc')

	local coA = coStream(fib)
	local coB = coStream(fac, hasBC and bc.new(1) or 1)

	p(coA:take(5))
	p(coA:take(5))
	p(coA:skip(30):take(1))

	p(coB:take(5))
	p(coB:take(5))
	p(coB:skip(89):take(1))
end
