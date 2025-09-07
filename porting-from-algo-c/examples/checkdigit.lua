--
--  from src/isbn.c
--
--    a part of main  to  isISBN10
--
--  from src/isbn13.c
--
--    a part of main  to  isISBN13
--
--  from src/luhn.c
--
--    a part of main  to  isLuhn
--

local M = require 'checkdigit'

local isISBN10, isISBN13, isLuhn = M.isISBN10, M.isISBN13, M.isLuhn

function p(s, predicate)
	print(("%s is %s."):format(s, predicate(s) and "valid" or "invalid"))
end

do
	p("4871483517", isISBN10)

	p("9784774196909", isISBN13)

	p("5555555555554444", isLuhn)

	-- samples from https://en.wikipedia.org/wiki/Luhn_algorithm
	p("79927398713", isLuhn)
	p("8961019501234400001", isLuhn)
	p("9501234400008", isLuhn)
end
