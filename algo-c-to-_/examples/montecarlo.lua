--
--	from src/monte.c
--
--	void monte1(int)	to	piA
--	void monte2(int)	to	piB
--	void monte3(int)	to	piC
--

local M0 = require 'crnd'
local M1 = require 'montecarlo'

local crnd = M0.crnd
local piA, piB, piC = M1.piA, M1.piB, M1.piC

function samples(target, formatter, tbl)
	for _,n in ipairs(tbl) do
		print(("%8d : %s"):format(n, formatter(target(n))))
	end
end

function targetR(f, seed)
	local rand = crnd()
	return function (n)
		rand:init(seed)
		return f(n, rand)
	end
end

function formatter1(n)
	return ("%6.4f (delta: %q)"):format(n, math.abs(math.pi - n))
end

function formatter2(m, n)
	return ("%6.4f +- %6.4f"):format(m, n)
end

do
	local seed = 123456789
	local tbl = {10000, 100000, 1000000}

	print("-------- piA n")
	samples(targetR(piA, seed), formatter2, tbl)

	print("-------- piB n")
	samples(targetR(piB, seed), formatter2, tbl)

	print("-------- piC n")
	samples(piC, formatter1, tbl)
end
