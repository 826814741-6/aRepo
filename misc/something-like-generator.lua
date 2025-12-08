--
--  something-like-generator.lua
--
--  > lua[jit] something-like-generator.lua
--

local H = require 'helper'

local alwaysTrue, beCircularG, bePrintablePair, id =
	H.alwaysTrue, H.beCircularG, H.bePrintablePair, H.id

local co_create = coroutine.create
local co_resume = coroutine.resume
local co_yield = coroutine.yield

local function dropCL(self, n)
	n = n ~= nil and n or 0
	for _=1,n do
		self.c()
	end
	return self
end
local function dropCO(self, n)
	n = n ~= nil and n or 0
	for _=1,n do
		co_resume(self.c)
	end
	return self
end

local function takeCL(self, n, f)
	n = n ~= nil and n or 0
	f = f ~= nil and f or id
	local r = {}
	for i=1,n do
		r[i] = f(self.c())
	end
	return self, r
end
local function takeCO(self, n, f)
	n = n ~= nil and n or 0
	f = f ~= nil and f or id
	local r = {}
	for i=1,n do
		local _, v = co_resume(self.c)
		r[i] = f(v)
	end
	return self, r
end

local function filterCL(self, n, f, g)
	n = n ~= nil and n or 0
	f = f ~= nil and f or alwaysTrue
	g = g ~= nil and g or id
	local r, i = {}, 1
	while i <= n do
		local v = self.c()
		if f(i, v) then
			r[i], i = g(v), i + 1
		end
	end
	return self, r
end
local function filterCO(self, n, f, g)
	n = n ~= nil and n or 0
	f = f ~= nil and f or alwaysTrue
	g = g ~= nil and g or id
	local r, i = {}, 1
	while i <= n do
		local _, v = co_resume(self.c)
		if f(i, v) then
			r[i], i = g(v), i + 1
		end
	end
	return self, r
end

local function gResume(co)
	return function ()
		local _, v = co_resume(co)
		return v
	end
end

local function peelCL(self)
	return self.c
end
local function peelCO(self)
	return self.aResume
end

local function init(v)
	local ty = type(v)
	if ty == "function" then
		return dropCL, takeCL, filterCL, peelCL
	elseif ty == "thread" then
		return dropCO, takeCO, filterCO, peelCO, gResume(v)
	else
		error("'v' must be a function or a thread.")
	end
end

local function beGen(v, ...)
	local T = { c = v(...) }

	T.drop, T.take, T.filter, T.peel, T.aResume = init(T.c)

	return T
end

local function dropGens(n, ...)
	local t = beCircularG(...)

	local i = 1
	for _=1,n do
		t[i].v()
		i = t[i].next
	end
end

local function takeGens(n, ...)
	local t = beCircularG(...)

	local r, i = {}, 1
	for j=1,n do
		r[j], i = t[i].v(), t[i].next
	end
	return r
end

do
	function iotaCL(start, step)
		start = start ~= nil and start or 0
		step = step ~= nil and step or 1
		local n = start - step
		return function ()
			n = n + step
			return n
		end
	end
	function iotaCO(start, step)
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

	function gFibCL(f)
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
	function gFibCO(f)
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

	function gCircularCL(...)
		local t = H.beCircular(...)
		local i = #t
		return function ()
			i = t[i].next
			return t[i].v
		end
	end
	function gCircularCO(...)
		local t = H.beCircular(...)
		local i = 1
		return co_create(function ()
			while true do
				co_yield(t[i].v)
				i = t[i].next
			end
		end)
	end

	--

	function a(_, r) return function (v) H.assertA(r, v) end end

	function demoA(v)
		a(beGen(v):take(10))({
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9
		})
		a(beGen(v, 50, -1):drop(50):take(10))({
			0, -1, -2, -3, -4, -5, -6, -7, -8, -9
		})
		a(beGen(v):take(10, function (v) return v * v * v end))({
			0, 1, 8, 27, 64, 125, 216, 343, 512, 729
		})
		a(beGen(v):filter(10, function (_, v) return v % 2 == 0 end))({
			0, 2, 4, 6, 8, 10, 12, 14, 16, 18
		})
	end

	demoA(iotaCL)
	demoA(iotaCO)

	--

	local buf = H.makeBuffer()

	function bwA(v) buf:push(v) end
	function bwB(v) buf:push(v) return v end

	function demoB(v)
		a(beGen(v):take(3, bwA))({})
		a(beGen(v):take(3, bwB))({0, 1, 2})
	end

	demoB(iotaCL)
	demoB(iotaCO)

	H.assertA(buf:get(), {
		0, 1, 2, 0, 1, 2,
		0, 1, 2, 0, 1, 2
	})
	buf:reset()

	function demoC(v)
		beGen(v)
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

	H.assertA(buf:get(), {
		6, 8, 10, 12, 14, 18, 21, 24, 27, 30,
		6, 8, 10, 12, 14, 18, 21, 24, 27, 30
	})
	buf:reset()

	--

	local hasBC, bc = pcall(require, 'bc')
	local fibPairCL, fibCO = gFibCL(bePrintablePair), gFibCO()

	local g1 = beGen(fibPairCL)
	local g2 = hasBC and beGen(fibCO, bc.new(0), bc.new(1)) or beGen(fibCO)

	H.assertA(takeGens(6, g1, g2), hasBC and {
		{0, 1}, bc.new(0), {1, 1}, bc.new(1), {1, 2}, bc.new(1)
	} or {
		{0, 1}, 0, {1, 1}, 1, {1, 2}, 1
	})
	dropGens(10, g1, g2)
	H.assertA(takeGens(6, g2, g1), hasBC and {
		bc.new(21), {21, 34}, bc.new(34), {34, 55}, bc.new(55), {55, 89}
	} or {
		21, {21, 34}, 34, {34, 55}, 55, {55, 89}
	})

	dropGens(112, g1, g2)
	print(H.unpackerR(g1:take(3)))
	print(H.unpackerR(g2:take(3)))
	dropGens(42, g1, g2)
	print(H.unpackerR(g1:take(3)))
	print(H.unpackerR(g2:take(3)))

	--

	local daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3 =
		beGen(gCircularCL, "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"),
		beGen(gCircularCO, "Jan", "Feb", "Mar", "Apr", "May", "Jun",
		                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
		beGen(gCircularCL, 0, 1, 2)

	dropGens(84 * 3, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3)
	H.assertA(
		takeGens(9, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3),
		{ "Sun", "Jan", 0, "Mon", "Feb", 1, "Tue", "Mar", 2 }
	)
	dropGens(7, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3)
	monthsOfTheYear:drop(1) remaindersDividedBy3:drop(1)
	H.assertA(
		takeGens(9, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3),
		{ "Sat", "Jul", 0, "Sun", "Aug", 1, "Mon", "Sep", 2 }
	)

	function demoD(g, m, n)
		local t, buf = 1, H.makeBuffer()

		for v in g:peel() do
			io.write(v, " ")
			t = t + 1
			buf:push(g:peel())
			if t > m then break end
			g:drop(n)
		end
		io.write("\n")

		for i=1,buf:len() do
			g:drop(n)
			io.write(buf:pop()(), " ")
		end
		io.write("\n")
	end

	demoD(daysOfTheWeek, 10)   -- ... Sun
	demoD(monthsOfTheYear, 15) -- ... Mar
	a(daysOfTheWeek:take(8))({
		"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon"
	})
	a(monthsOfTheYear:take(13))({
		"Apr", "May", "Jun", "Jul", "Aug", "Sep",
		"Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr"
	})

	function predA() return H.unpackerR(remaindersDividedBy3:take(1)) == 0 end
	function predB() return remaindersDividedBy3:peel()() == 0 end

	demoD(daysOfTheWeek, 5, 2)   -- ... Mon
	demoD(monthsOfTheYear, 5, 2) -- ... Aug
	a(daysOfTheWeek:filter(10, predA))({   -- 0 1 2 0 1 2 ... 1 2 0
		"Tue", "Fri", "Mon", "Thu", "Sun", "Wed", "Sat", "Tue", "Fri", "Mon"
	})
	a(monthsOfTheYear:filter(10, predB))({ -- 1 2 0 1 2 0 ... 1 2 0
		"Nov", "Feb", "May", "Aug", "Nov", "Feb", "May", "Aug", "Nov", "Feb"
	})
end
