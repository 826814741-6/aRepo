--
--	from src/isbn13.c
--
--	a part of main		to	isIsbn13
--

local M = require 'checkdigit'

local isISBN13 = M.isISBN13

do
	local s = "9784774196909"
	print(("%s is %s."):format(s, isISBN13(s) and "valid" or "invalid"))
end
