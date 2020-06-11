--
--	from src/movebloc.c
--
--	void reverse(int, int)		to	reverse
--	void rotate(int, int, int)	to	rotate
--

local M = require 'moveblock'

local reverse, rotate = M.reverse, M.rotate

do
	local s = "SUPERCALIFRAGILISTICEXPIALIDOCIOUS"

	local a = {}
	for i=1,#s do a[i] = s:sub(i,i) end

	reverse(a, 1, #a)
	reverse(a, 1, #a)
	assert(s == table.concat(a))

	print(table.concat(a))
	for _=1,17 do
		rotate(a, 1, 6, #a)
		print(table.concat(a))
	end
end
