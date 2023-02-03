--
--	from src/factoriz.c
--
--	void factorize(int)	to	factorize
--	factorize		to	factorizeM (depends lbc(*))
--	factorize		to	factorizeT
--	factorize		to	factorizeCO (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'factorize'

local factorize = M.factorize
local factorizeM = M.factorizeM
local factorizeT = M.factorizeT
local factorizeCO = M.factorizeCO

function demo1(n, start)
	start = start ~= nil and start or 1

	for i=start,n do
		io.write(("%5d = "):format(i))
		factorize(i)

		io.write(("%5d = "):format(i))
		factorizeM(i)

		io.write(("%5d = "):format(i))
		io.write(table.concat(factorizeT(i), " * "), "\n")
	end
end

function demo2(n)
	function g(co, ...)
		local _, v = coroutine.resume(co, ...)
		return v
	end

	local bc = require 'bc'
	local TWO = bc.new(2)
	function assert_TWO(i, v)
		assert(
			v == TWO,
			("ERROR: %dth is not 2. (%s)"):format(i, tostring(v))
		)
	end

	local co = factorizeCO()

	local v = g(co, TWO ^ n * 997 * 10007)
	assert_TWO(1, v)
	for i=2,n do
		v = g(co)
		assert_TWO(i, v)
	end

	assert(g(co) == bc.new(997))
	assert(g(co) == bc.new(10007))
end

do
	demo1(100)
	demo2(10000)
end
