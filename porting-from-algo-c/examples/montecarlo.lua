--
--  from src/monte.c
--
--    void monte1(int)  to  piA
--    void monte2(int)  to  piB
--    void monte3(int)  to  piC
--

local M0 = require 'crnd'
local M1 = require 'montecarlo'

local crnd = M0.crnd
local piA, piB = M1.piA, M1.piB
local piC = M1.piC

function printSamples(target, fmt, tbl)
	for _,n in ipairs(tbl) do
		print(("%8d : %s"):format(n, fmt(target(n))))
	end
end

function makeTarget(f, seed)
	local rand = crnd()
	return function (n)
		rand:init(seed)
		return f(n, rand)
	end
end

function fmtAB(m, n)
	return ("%6.4f +- %6.4f"):format(m, n)
end

function fmtC(n)
	return ("%6.4f (delta: %q)"):format(n, math.abs(math.pi - n))
end

do
	local seed = 123456789
	local tbl = {10000, 100000, 1000000}

	print("-------- piA n")
	printSamples(makeTarget(piA, seed), fmtAB, tbl)

	print("-------- piB n")
	printSamples(makeTarget(piB, seed), fmtAB, tbl)

	print("-------- piC n")
	printSamples(piC, fmtC, tbl)
end
