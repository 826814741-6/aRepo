--
--  something-like-generator.lua
--
--  > lua[jit] something-like-generator.lua
--

local H = require 'helper'

local beCircular, beCircularL, id = H.beCircular, H.beCircularL, H.id

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
		return v
	elseif ty == "thread" then
		return gResume(v)
	else
		error("'v' must be a function or a thread.")
	end
end

local function peel(self) return self.v end
local function hookG(v) return v:peel() end

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

local function GSL_dropF(v, n)
	for _=1,n do v.v() v = v.next end
end
local function GSL_dropB(v, n)
	v = v.prev
	for _=1,n do v.v() v = v.prev end
end
local function GSL_dropMF(v, n)
	for _=1,n do v.v.v() v.v = v.v.next end
end
local function GSL_dropMB(v, n)
	v.v = v.v.prev
	for _=1,n do v.v.v() v.v = v.v.prev end
end

local function GSL_drop(self, n)
	if n < 0 then GSL_dropB(self.v, -n) else GSL_dropF(self.v, n) end
	return self
end
local function GSL_dropM(self, n)
	if n < 0 then GSL_dropMB(self, -n) else GSL_dropMF(self, n) end
	return self
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

local function GSL_takeF(v, n, f)
	local r = {}
	for i=1,n do r[i], v = f(v.v()), v.next end
	return r
end
local function GSL_takeB(v, n, f)
	local r = {} v = v.prev
	for i=1,n do r[i], v = f(v.v()), v.prev end
	return r
end
local function GSL_takeMF(v, n, f)
	local r = {}
	for i=1,n do r[i], v.v = f(v.v.v()), v.v.next end
	return r
end
local function GSL_takeMB(v, n, f)
	local r = {} v.v = v.v.prev
	for i=1,n do r[i], v.v = f(v.v.v()), v.v.prev end
	return r
end

local function GSL_take(self, n, f)
	f = f ~= nil and f or id
	if n < 0 then
		return self, GSL_takeB(self.v, -n, f)
	else
		return self, GSL_takeF(self.v, n, f)
	end
end
local function GSL_takeM(self, n, f)
	f = f ~= nil and f or id
	if n < 0 then
		return self, GSL_takeMB(self, -n, f)
	else
		return self, GSL_takeMF(self, n, f)
	end
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

local function GSL_filterF(v, n, pred, f)
	local r, i = {}, 1
	while i <= n do
		local t = v.v()
		v = v.next
		if pred(i, t) then r[i], i = f(t), i + 1 end
	end
	return r
end
local function GSL_filterB(v, n, pred, f)
	local r, i = {}, 1
	v = v.prev
	while i <= n do
		local t = v.v()
		v = v.prev
		if pred(i, t) then r[i], i = f(t), i + 1 end
	end
	return r
end
local function GSL_filterMF(v, n, pred, f)
	local r, i = {}, 1
	while i <= n do
		local t = v.v.v()
		v.v = v.v.next
		if pred(i, t) then r[i], i = f(t), i + 1 end
	end
	return r
end
local function GSL_filterMB(v, n, pred, f)
	local r, i = {}, 1
	v.v = v.v.prev
	while i <= n do
		local t = v.v.v()
		v.v = v.v.prev
		if pred(i, t) then r[i], i = f(t), i + 1 end
	end
	return r
end

local function GSL_filter(self, n, pred, f)
	f = f ~= nil and f or id
	if n < 0 then
		return self, GSL_filterB(self.v, -n, pred, f)
	else
		return self, GSL_filterF(self.v, n, pred, f)
	end
end
local function GSL_filterM(self, n, pred, f)
	f = f ~= nil and f or id
	if n < 0 then
		return self, GSL_filterMB(self, -n, pred, f)
	else
		return self, GSL_filterMF(self, n, pred, f)
	end
end

local function GSL_reset(self)
	self.v = self.HEAD
	return self
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

local function GensL(...)
	local T = { v = beCircularL(hookG, ...) }

	T.drop, T.take, T.filter = GSL_drop, GSL_take, GSL_filter
	T.dropM, T.takeM, T.filterM = GSL_dropM, GSL_takeM, GSL_filterM
	T.HEAD, T.reset = T.v, GSL_reset

	return T
end

local function _r(_, r) return r end

local function drop(g, n) G_drop(g, n) end
local function take(g, n, f) return _r(G_take(g, n, f)) end
local function filter(g, n, pred, f) return _r(G_filter(g, n, pred, f)) end

local function dropGens(n, ...) Gens(...):drop(n) end
local function takeGens(n, ...) return _r(Gens(...):take(n)) end
local function filterGens(n, pred, ...) return _r(Gens(...):filter(n, pred)) end

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
local function gCircularLCL(...)
	local v = beCircularL(id, ...).prev
	return function ()
		v = v.next
		return v.v
	end
end
local function gCircularLCLb(...)
	local v = beCircularL(id, ...)
	return function ()
		v = v.prev
		return v.v
	end
end
local function gCircularLCO(...)
	local v = beCircularL(id, ...)
	return co_create(function ()
		while true do
			co_yield(v.v)
			v = v.next
		end
	end)
end
local function gCircularLCOb(...)
	local v = beCircularL(id, ...).prev
	return co_create(function ()
		while true do
			co_yield(v.v)
			v = v.prev
		end
	end)
end

do
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
			_r( GensL(Gen(v, 50, -1), Gen(v, 50, -1)):drop(100):take(10) ),
			{0, 0, -1, -1, -2, -2, -3, -3, -4, -4}
		)
		H.assertA(
			_r( Gen(v):take(10, hook) ),
			{0, 1, 8, 27, 64, 125, 216, 343, 512, 729}
		)
		H.assertA(
			take(Gen(v), 10, hook),
			{0, 1, 8, 27, 64, 125, 216, 343, 512, 729}
		)
		H.assertA(
			_r( Gens(Gen(v), Gen(v)):take(10, hook) ),
			{0, 0, 1, 1, 8, 8, 27, 27, 64, 64}
		)
		H.assertA(
			_r( GensL(Gen(v), Gen(v)):take(10, hook) ),
			{0, 0, 1, 1, 8, 8, 27, 27, 64, 64}
		)
		H.assertA(
			_r( Gen(v):filter(10, pred) ),
			{0, 2, 4, 6, 8, 10, 12, 14, 16, 18}
		)
		H.assertA(
			filter(Gen(v), 10, pred),
			{0, 2, 4, 6, 8, 10, 12, 14, 16, 18}
		)
		H.assertA(
			_r( Gens(Gen(v), Gen(v)):filter(10, pred) ),
			{0, 0, 2, 2, 4, 4, 6, 6, 8, 8}
		)
		H.assertA(
			_r( GensL(Gen(v), Gen(v)):filter(10, pred) ),
			{0, 0, 2, 2, 4, 4, 6, 6, 8, 8}
		)
		H.assertA(
			filterGens(10, pred, Gen(v), Gen(v)),
			{0, 0, 2, 2, 4, 4, 6, 6, 8, 8}
		)
		H.assertA(
			_r( Gens(Gen(v,2), Gen(v,5,5), Gen(v,10,10)):filter(10, pred) ),
			{2, 10, 10, 20, 4, 30, 20, 40, 6, 50}
		)
		H.assertA(
			_r( GensL(Gen(v,2), Gen(v,5,5), Gen(v,10,10)):filter(10, pred) ),
			{2, 10, 10, 20, 4, 30, 20, 40, 6, 50}
		)
		H.assertA(
			filterGens(10, pred, Gen(v,2), Gen(v,5,5), Gen(v,10,10)),
			{2, 10, 10, 20, 4, 30, 20, 40, 6, 50}
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
		dropGens(9, g, g, g, g)
		H.assertA(
			_r( GensL(g, g, g):drop(-1):take(10) ),
			{40, 41, 42, 43, 44, 45, 46, 47, 48, 49}
		)
		H.assertA(
			takeGens(10, g, g, g, g, g),
			{50, 51, 52, 53, 54, 55, 56, 57, 58, 59}
		)
	end

	demoA(iotaCL)
	demoA(iotaCO)

	--

	local buf = H.makeBuffer()

	function bwA(v) buf:push(v) end
	function bwB(v) buf:push(v) return v end

	function demoB(v)
		H.assertA(
			_r( Gen(v):take(3, bwA) ),
			take(Gen(v), 3, bwA),
			{}
		)
		H.assertA(
			_r( Gen(v):take(3, bwB) ),
			take(Gen(v), 3, bwB),
			{0, 1, 2}
		)
	end

	demoB(iotaCL)
	demoB(iotaCO)

	H.assertA(
		buf:get(),
		{0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2,
		 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2}
	)
	buf:reset()

	function demoC(v)
		function predA(_, v) return v % 2 == 0 end
		function predB(_, v) return v % 3 == 0 end

		local g = Gen(v)

		drop(g, 5) -- 0, 1, 2, 3, 4
		H.assertA(filter(g, 5, predA, bwB), {6, 8, 10, 12, 14})
		drop(g, 3) -- 15, 16, 17

		H.assertA(
			filter(g, 5, predB),
			_r( Gen(v)
				:drop(5)
				:filter(5, predA, bwA)
				:drop(3)
				:filter(5, predB) ),
			{18, 21, 24, 27, 30}
		)
	end

	demoC(iotaCL)
	demoC(iotaCO)

	H.assertA(
		buf:get(),
		{6, 8, 10, 12, 14, 6, 8, 10, 12, 14,
		 6, 8, 10, 12, 14, 6, 8, 10, 12, 14}
	)
	buf:reset()

	--

	local hasBC, bc = pcall(require, 'bc')

	function demoD(v1, v2, v3)
		local fibPair, fib = v1(H.bePrintablePair), v2()

		local g1 = Gen(fibPair)
		local g2 = hasBC and Gen(fib, bc.new(0), bc.new(1)) or Gen(fib)
		local gs = v3(g1, g2)

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

	demoD(gFibCL, gFibCO, Gens)
	demoD(gFibCO, gFibCL, Gens)
	demoD(gFibCL, gFibCO, GensL)
	demoD(gFibCO, gFibCL, GensL)

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

	function demoE(v1, v2, v3)
		local g1, g2, g3 =
			Gen(v1, "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"),
			Gen(v2, "Jan", "Feb", "Mar", "Apr", "May", "Jun",
			        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
			Gen(v1, 0, 1, 2)
		local gs1, gs2 = v3(g1, g2, g3), v3(g3, g3, g3, g3, g3)

		gs1:drop(84 * 3)
		H.assertA(
			_r( gs1:take(9) ),
			{"Sun", "Jan", 0, "Mon", "Feb", 1, "Tue", "Mar", 2}
		)
		gs1:drop(7) g2:drop(1) drop(g3, 1)
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
		dropGens(4, g3, g3, g3, g3, g3, g3) -- 1 2 0 1
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

	demoE(gCircularCL, gCircularCO, Gens)
	demoE(gCircularCO, gCircularCL, Gens)
	demoE(gCircularCL, gCircularCO, GensL)
	demoE(gCircularCO, gCircularCL, GensL)
	demoE(gCircularLCL, gCircularLCO, Gens)
	demoE(gCircularLCO, gCircularLCL, Gens)
	demoE(gCircularLCL, gCircularLCO, GensL)
	demoE(gCircularLCO, gCircularLCL, GensL)

	--

	function demoF(v1, v2)
		function pred(_, v) return v % 2 == 0 end

		local gs = GensL(Gen(v1), Gen(v2, 0, -1), Gen(v1, 50, -1))

		H.assertA(
			_r( gs:take(5) ),
			{0, 0, 50, 1, -1}
		)
		gs:drop(5) -- 2, -2, 49, 3, -3
		H.assertA(
			_r( gs:takeM(5) ),
			_r( GensL(Gen(v2,50,-1), Gen(v1,0,-1), Gen(v2))
				:take(-5)
				:drop(-5)
				:takeM(-5) ),
			{4, -4, 48, 5, -5}
		)
		H.assertA(
			_r( gs:take(5) ),
			{47, 6, -6, 46, 7}
		)
		gs:dropM(5) -- 45, 8, -7, 44, 9
		H.assertA(
			_r( gs:take(5) ),
			{-8, 43, 10, -9, 42}
		)
		H.assertA(
			_r( gs:take(5) ),
			{-10, 41, 11, -11, 40}
		)
		gs:reset()
		H.assertA(
			_r( gs:take(5) ),
			{12, -12, 39, 13, -13}
		)
		gs:dropM(-5) -- 38, -14, 14, 37, -15
		H.assertA(
			_r( gs:take(5) ),
			{15, -16, 36, 16, -17}
		)
	end

	demoF(iotaCL, iotaCO)
	demoF(iotaCO, iotaCL)
end
