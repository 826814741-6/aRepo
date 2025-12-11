--
--  something-like-generator.lua
--
--  > lua[jit] something-like-generator.lua
--

local H = require 'helper'

local beCircular, id = H.beCircular, H.id

local co_create = coroutine.create
local co_resume = coroutine.resume
local co_yield = coroutine.yield

local function gResume(co)
	return function ()
		local _, v = co_resume(co)
		return v
	end
end

local function init(v)
	local ty = type(v)
	if ty == "function" then
		return id(v)
	elseif ty == "thread" then
		return gResume(v)
	else
		error("'v' must be a function or a thread.")
	end
end

local function peel(self) return self.v end
local function hookG(v) return v:peel() end

local function drop(g, n)
	for _=1,n do g() end
end
local function G_drop(self, n)
	for _=1,n do self.v() end
	return self
end
local function GS_drop(self, n)
	local i = 1
	for _=1,n do
		self.v[i].v()
		i = self.v[i].next
	end
	return self
end
local function dropGens(n, ...)
	local t = beCircular(hookG, ...)

	local i = 1
	for _=1,n do
		t[i].v()
		i = t[i].next
	end
end

local function take(g, n, f)
	f = f ~= nil and f or id
	local r = {}
	for i=1,n do r[i] = f(g()) end
	return r
end
local function G_take(self, n, f)
	f = f ~= nil and f or id
	local r = {}
	for i=1,n do
		r[i] = f(self.v())
	end
	return self, r
end
local function GS_take(self, n, f)
	f = f ~= nil and f or id
	local r, i = {}, 1
	for j=1,n do
		r[j], i = f(self.v[i].v()), self.v[i].next
	end
	return self, r
end
local function takeGens(n, ...)
	local t = beCircular(hookG, ...)

	local r, i = {}, 1
	for j=1,n do
		r[j], i = t[i].v(), t[i].next
	end
	return r
end

local function filter(g, n, pred, f)
	f = f ~= nil and f or id
	local r, i = {}, 1
	while i <= n do
		local v = g()
		if pred(i, v) then
			r[i], i = v, i + 1
		end
	end
	return r
end
local function G_filter(self, n, pred, f)
	f = f ~= nil and f or id
	local r, i = {}, 1
	while i <= n do
		local v = self.v()
		if pred(i, v) then
			r[i], i = f(v), i + 1
		end
	end
	return self, r
end
local function GS_filter(self, n, pred, f)
	f = f ~= nil and f or id
	local r, i, j = {}, 1, 1
	while j <= n do
		local v = self.v[i].v()
		i = self.v[i].next
		if pred(j, v) then
			r[j], j = f(v), j + 1
		end
	end
	return self, r
end
local function filterGens(n, pred, ...)
	local t = beCircular(hookG, ...)

	local r, i, j = {}, 1, 1
	while j <= n do
		local v = t[i].v()
		i = t[i].next
		if pred(j, v) then
			r[j], j = v, j + 1
		end
	end
	return r
end

local function Gen(v, ...)
	local T = { v = init(v(...)) }

	T.peel, T.drop, T.take, T.filter = peel, G_drop, G_take, G_filter

	return T
end

local function Gens(...)
	local T = { v = beCircular(hookG, ...) }

	T.drop, T.take, T.filter = GS_drop, GS_take, GS_filter

	return T
end

--

local function iotaCL(start, step)
	start = start ~= nil and start or 0
	step = step ~= nil and step or 1
	local n = start - step
	return function ()
		n = n + step
		return n
	end
end
local function iotaCO(start, step)
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

local function gFibCL(f)
	f = f ~= nil and f or function (l, _) return l end
	return function (zero, one)
		zero = zero ~= nil and zero or 0
		one = one ~= nil and one or 1
		local a, b = one, zero
		return function ()
			a, b = b, a + b
			return f(a, b)
		end
	end
end
local function gFibCO(f)
	f = f ~= nil and f or function (l, _) return l end
	return function (zero, one)
		zero = zero ~= nil and zero or 0
		one = one ~= nil and one or 1
		return co_create(function ()
			local a, b = zero, one
			while true do
				co_yield(f(a, b))
				a, b = b, a + b
			end
		end)
	end
end

local function gCircularCL(...)
	local t = beCircular(id, ...)
	local i = #t
	return function ()
		i = t[i].next
		return t[i].v
	end
end
local function gCircularCO(...)
	local t = beCircular(id, ...)
	local i = 1
	return co_create(function ()
		while true do
			co_yield(t[i].v)
			i = t[i].next
		end
	end)
end

do
	function _r(_, r) return r end

	function demoA(v)
		function hook(v) return v * v * v end
		function pred(_, v) return v % 2 == 0 end

		H.assertA(
			_r( Gen(v):take(10) ),
			{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
		)
		H.assertA(
			_r( Gen(v, 50, -1):drop(50):take(10) ),
			{0, -1, -2, -3, -4, -5, -6, -7, -8, -9}
		)
		H.assertA(
			_r( Gens(Gen(v, 50, -1), Gen(v, 50, -1)):drop(100):take(10) ),
			{0, 0, -1, -1, -2, -2, -3, -3, -4, -4}
		)
		H.assertA(
			_r( Gen(v):take(10, hook) ),
			{0, 1, 8, 27, 64, 125, 216, 343, 512, 729}
		)
		H.assertA(
			take(Gen(v):peel(), 10, hook),
			{0, 1, 8, 27, 64, 125, 216, 343, 512, 729}
		)
		H.assertA(
			_r( Gens(Gen(v), Gen(v)):take(10, hook) ),
			{0, 0, 1, 1, 8, 8, 27, 27, 64, 64}
		)
		H.assertA(
			_r( Gen(v):filter(10, pred) ),
			{0, 2, 4, 6, 8, 10, 12, 14, 16, 18}
		)
		H.assertA(
			filter(Gen(v):peel(), 10, pred),
			{0, 2, 4, 6, 8, 10, 12, 14, 16, 18}
		)
		H.assertA(
			_r( Gens(Gen(v), Gen(v)):filter(10, pred) ),
			{0, 0, 2, 2, 4, 4, 6, 6, 8, 8}
		)
		H.assertA(
			filterGens(10, pred, Gen(v), Gen(v)),
			{0, 0, 2, 2, 4, 4, 6, 6, 8, 8}
		)
		local g = Gen(v)
		H.assertA(
			filterGens(10, pred, g, g, g),
			{0, 2, 4, 6, 8, 10, 12, 14, 16, 18}
		)
		H.assertA(
			_r( Gens(g, g, g):drop(1):take(10) ),
			{20, 21, 22, 23, 24, 25, 26, 27, 28, 29}
		)
		dropGens(10, g, g, g, g)
		H.assertA(
			takeGens(10, g, g, g, g, g),
			{40, 41, 42, 43, 44, 45, 46, 47, 48, 49}
		)
	end

	demoA(iotaCL)
	demoA(iotaCO)

	--

	local buf = H.makeBuffer()

	function bwA(v) buf:push(v) end
	function bwB(v) buf:push(v) return v end

	function demoB(v)
		H.assertA(_r( Gen(v):take(3, bwA) ), {})
		H.assertA(_r( Gen(v):take(3, bwB) ), {0, 1, 2})
	end

	demoB(iotaCL)
	demoB(iotaCO)

	H.assertA(
		buf:get(),
		{0, 1, 2, 0, 1, 2,
		 0, 1, 2, 0, 1, 2}
	)
	buf:reset()

	function demoC(v)
		Gen(v)
			:drop(5) -- 0, 1, 2, 3, 4
			:filter(
				5,
				function (_, v) return v % 2 == 0 end,
				bwA
			)        -- 6, 8, 10, 12, 14
			:drop(3) -- 15, 16, 17
			:filter(
				5,
				function (_, v) return v % 3 == 0 end,
				bwA
			)        -- 18, 21, 24, 27, 30
	end

	demoC(iotaCL)
	demoC(iotaCO)

	H.assertA(
		buf:get(),
		{6, 8, 10, 12, 14, 18, 21, 24, 27, 30,
		 6, 8, 10, 12, 14, 18, 21, 24, 27, 30}
	)
	buf:reset()

	--

	local hasBC, bc = pcall(require, 'bc')

	function demoD(v1, v2)
		local fibPair, fib = v1(H.bePrintablePair), v2()

		local g1 = Gen(fibPair)
		local g2 = hasBC and Gen(fib, bc.new(0), bc.new(1)) or Gen(fib)
		local gs = Gens(g1, g2)

		H.assertA(
			_r( gs:take(6) ),
			hasBC
			and {{0, 1}, bc.new(0), {1, 1}, bc.new(1), {1, 2}, bc.new(1)}
			or {{0, 1}, 0, {1, 1}, 1, {1, 2}, 1}
		)
		gs:drop(10)
		H.assertA(
			_r( gs:take(6) ),
			hasBC
			and {{21, 34}, bc.new(21), {34, 55}, bc.new(34), {55, 89}, bc.new(55)}
			or {{21, 34}, 21, {34, 55}, 34, {55, 89}, 55}
		)
	end

	demoD(gFibCL, gFibCO)
	demoD(gFibCO, gFibCL)

	local g1 = Gen(gFibCL(H.bePrintablePair))
	local g2 = hasBC and Gen(gFibCO(), bc.new(0), bc.new(1)) or Gen(fibCO())
	local gs = Gens(g1, g2)

	gs:drop(134)
	print(H.unpackerR(g1:take(3)))
	print(H.unpackerR(g2:take(3)))
	gs:drop(42)
	print(H.unpackerR(g1:take(3)))
	print(H.unpackerR(g2:take(3)))

	--

	function demoE(v1, v2)
		local g1, g2, g3 =
			Gen(v1, "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"),
			Gen(v2, "Jan", "Feb", "Mar", "Apr", "May", "Jun",
			        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
			Gen(v1, 0, 1, 2)
		local gs1, gs2 = Gens(g1, g2, g3), Gens(g3, g3, g3, g3, g3)

		gs1:drop(84 * 3)
		H.assertA(
			_r( gs1:take(9) ),
			{"Sun", "Jan", 0, "Mon", "Feb", 1, "Tue", "Mar", 2}
		)
		gs1:drop(7) g2:drop(1) drop(g3:peel(), 1)
		H.assertA(
			_r( gs1:take(9) ),
			{"Sat", "Jul", 0, "Sun", "Aug", 1, "Mon", "Sep", 2}
		)

		function pred() return g3:peel()() == 0 end

		H.assertA(
			_r( g1:filter(8, pred) ), -- 0 1 2 0 1 2 ... 1 2 0
			{"Tue", "Fri", "Mon", "Thu", "Sun", "Wed", "Sat", "Tue"}
		)
		gs2:drop(3) -- 1 2 0
		H.assertA(
			_r( g2:filter(5, pred) ), -- 1 2 0 1 2 0 ... 1 2 0
			{"Dec", "Mar", "Jun", "Sep", "Dec"}
		)
		dropGens(4, g3, g3, g3, g3, g3, g3, g3) -- 1 2 0 1
		H.assertA(
			_r( g2:filter(5, pred) ), -- 2 0 1 2 0 1 ... 1 2 0
			{"Feb", "May", "Aug", "Nov", "Feb"}
		)
		gs2:drop(5) -- 1 2 0 1 2
		H.assertA(
			_r( g1:filter(8, pred) ), -- 0 1 2 0 1 2 ... 1 2 0
			{"Wed", "Sat", "Tue", "Fri", "Mon", "Thu", "Sun", "Wed"}
		)
	end

	demoE(gCircularCL, gCircularCO)
	demoE(gCircularCO, gCircularCL)
end
