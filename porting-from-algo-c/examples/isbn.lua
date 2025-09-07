--
--  from src/isbn.c
--
--    a part of main  to  isISBN10
--

local isISBN10 = require 'checkdigit'.isISBN10

do
	local s = "4871483517"
	print(("%s is %s."):format(s, isISBN10(s) and "valid" or "invalid"))
end
