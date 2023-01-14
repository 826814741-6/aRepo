--
--	from src/komachi.c
--
--	a part of main		to	komachi
--

local M = require 'komachi'

local komachi = M.komachi
local write, insert = io.write, table.insert

function p(a)
	for i=1,9 do
		write(a[i] == 1 and " + " or a[i] == -1 and " - " or "", i)
	end
	write(" = 100\n");
end

function b()
	local T = { buffer = {} }

	T.insert = function (a)
		local r = {}
		for i,v in ipairs(a) do r[i] = a[i] end
		insert(T.buffer, r)
	end

	T.print = function ()
		for _,v in ipairs(T.buffer) do p(v) end
	end

	return T
end

do
	print("-------- print komachi")
	komachi(p)

	print("-------- print komachi (with buffer)")
	local buffer = b()
	komachi(buffer.insert)
	buffer.print()
end
