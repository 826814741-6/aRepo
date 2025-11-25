--
--  something-like-generator.lua
--
--  > lua[jit] something-like-generator.lua
--

local H = require 'helper'

local alwaysTrue, beCircular, bePrintablePair, id, unpackerR =
	H.alwaysTrue, H.beCircular, H.bePrintablePair, H.id, H.unpackerR

local co_create = coroutine.create
local co_resume = coroutine.resume
local co_yield = coroutine.yield

local function dropCL(self, n)
	n = n ~= nil and n or 0
	for _=1,n do
		self.c()
	end
	return self, {}
end
local function dropCO(self, n)
	n = n ~= nil and n or 0
	for _=1,n do
		co_resume(self.c)
	end
	return self, {}
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

local function peelCL(self)
	return self.c
end
local function peelCO(self)
	return function ()
		local _, v = co_resume(self.c)
		return v
	end
end

local function makeMethod(v)
	local ty = type(v)
	if ty == "function" then
		return dropCL, takeCL, filterCL, peelCL
	elseif ty == "thread" then
		return dropCO, takeCO, filterCO, peelCO
	else
		error("'v' must be a function or a thread.")
	end
end

local function beGen(v, ...)
	local T = { c = v(...) }

	T.drop, T.take, T.filter, T.peel = makeMethod(T.c)

	return T
end

local function dropGens(n, ...)
	local t = beCircular(...)

	local i, j = 1, 1
	while i <= n do
		t[j].v:drop(1)
		i, j = i + 1, t[j].next
	end
end

local function takeGens(n, ...)
	local t = beCircular(...)

	local r, i, j = {}, 1, 1
	while i <= n do
		r[i], i, j = unpackerR(t[j].v:take(1)), i + 1, t[j].next
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

	function facCL(one)
		one = one ~= nil and one or 1
		local n, acc = one, one
		return function ()
			n, acc = n + one, acc * n
			return acc
		end
	end
	function facCO(one)
		one = one ~= nil and one or 1
		return co_create(function ()
			local n, acc = one, one
			while true do
				n, acc = n + one, acc * n
				co_yield(acc)
			end
		end)
	end

	function gCircularCL(...)
		local t = beCircular(...)
		local i = #t
		return function ()
			i = t[i].next
			return t[i].v
		end
	end
	function gCircularCO(...)
		local t = beCircular(...)
		local i = 1
		return co_create(function ()
			while true do
				co_yield(t[i].v)
				i = t[i].next
			end
		end)
	end

	--

	local t_unpack = table.unpack ~= nil and table.unpack or unpack

	function p(l, r) print(t_unpack(r ~= nil and r or H.flattenOnce(l))) end

	p(beGen(iotaCL):take(10))
	p(beGen(iotaCL, 50, -1):drop(50):take(10))
	p(beGen(iotaCL):take(10, function (v) return v * v * v end))
	p(beGen(iotaCL):filter(10, function (_, v) return v % 2 == 0 end))

	p(beGen(iotaCO):take(10))
	p(beGen(iotaCO, 50, -1):drop(50):take(10))
	p(beGen(iotaCO):take(10, function (v) return v * v * v end))
	p(beGen(iotaCO):filter(10, function (_, v) return v % 2 == 0 end))

	print("--")

	local buf = H.makeBuffer()

	function bwA(v) buf:insert(v) end
	function bwB(v) buf:insert(v) return v end

	p(beGen(iotaCL):take(3))      -- 0, 1, 2
	p(beGen(iotaCL):take(3, bwA)) -- (nothing printed)
	p(beGen(iotaCL):take(3, bwB)) -- 0, 1, 2

	p(beGen(iotaCO):take(3))      -- 0, 1, 2
	p(beGen(iotaCO):take(3, bwA)) -- (nothing printed)
	p(beGen(iotaCO):take(3, bwB)) -- 0, 1, 2

	p(buf:get()) -- 0, 1, 2, 0, 1, 2 x 2
	buf:reset()

	beGen(iotaCL)
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
	beGen(iotaCO)
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

	p(buf:get()) -- 6, 8, 10, 12, 14, 18, 21, 24, 27, 30 x 2
	buf:reset()

	print("--")

	local hasBC, bc = pcall(require, 'bc')
	local fibPairCL, fibCO = gFibCL(bePrintablePair), gFibCO()

	local g1 = beGen(fibPairCL)
	local g2 = hasBC and beGen(fibCO, bc.new(0), bc.new(1)) or beGen(fibCO)
	local g3 = beGen(facCL, hasBC and bc.new(1) or 1)
	local g4 = beGen(facCO)

	p(takeGens(10, g1, g2))
	p(g1:take(5))
	p(g2:take(5))
	dropGens(164, g2, g1)
	p(takeGens(4, g1, g2))

	dropGens(8, g4, g3)
	p(takeGens(10, g3, g4))
	dropGens(20, g3, g4)
	p(g3:take(3))
	p(g4:take(3))

	print("--")

	local daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3 =
		beGen(gCircularCL, "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"),
		beGen(gCircularCO, "Jan", "Feb", "Mar", "Apr", "May", "Jun",
		                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
		beGen(gCircularCL, 0, 1, 2)

	dropGens(84 * 3, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3)
	p(takeGens(9, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3))
	dropGens(7, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3)
	monthsOfTheYear:drop(1) remaindersDividedBy3:drop(1)
	p(takeGens(9, daysOfTheWeek, monthsOfTheYear, remaindersDividedBy3))

	print("--")

	function p(g, n)
		local t = 1
		for v in g:peel() do
			if t > n then break end
			io.write(v, " ")
			t = t + 1
		end
		io.write("\n")
	end

	p(daysOfTheWeek, 10)
	p(monthsOfTheYear, 15)
end
