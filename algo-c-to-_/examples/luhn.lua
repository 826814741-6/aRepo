--
--	from src/luhn.c
--
--	a part of main		to	isLuhn
--

local M = require 'checkdigit'

local isLuhn = M.isLuhn

function p(s)
	print(("%s is %s."):format(s, isLuhn(s) and "valid" or "invalid"))
end

do
	p("5555555555554444")

	-- samples from https://en.wikipedia.org/wiki/Luhn_algorithm
	p("79927398713")
	p("8961019501234400001")
	p("9501234400008")
end
