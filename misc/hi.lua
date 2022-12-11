--
--	Hello, World! in Lua/LuaJIT
--
--	with something like GNU dc's P command:
--	$ dc -e "1468369091346906859060166438166794P"
--	(see https://github.com/nobi56/aRepo/blob/master/misc/hi.sh)
--
--	depends on lbc-101; https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc
--

local M = require 'bc'

local M_new, M_quotrem, M_tonumber = M.new, M.quotrem, M.tonumber
--
local I_write = io.write
local S_char = string.char
local T_concat, T_insert = table.concat, table.insert

function hi(src)
	local T = {
		source = M_new(src);
		candidate = {}
	}

	function T:P()
		I_write(T_concat(T.candidate))
	end

	function T:n()
		I_write(tostring(T.source))
	end

	function T:n10P()
		I_write(tostring(T.source), "\n")
	end

	function makeCandidate()
		local n, edge = T.source, M_new(255)
		while n > edge do
			local q, r = M_quotrem(n, 256)
			T_insert(T.candidate, 1, S_char(M_tonumber(r)))
			n = q
		end
		T_insert(T.candidate, 1, S_char(M_tonumber(n)))
	end

	makeCandidate()

	return T
end

-- and some utils

function tbl2src(t)
	local r, j, step = M_new(0), 0, M_new(256)

	for i=#t,1,-1 do
		r, j = r + t[i] * (step ^ j), j + 1
	end

	return r
end

function split(s, p, f)
	local r = {}

	for e in s:gmatch(p) do
		T_insert(r, f(e))
	end

	return r
end

function str2src(s)
	return tbl2src({ s:byte(1, -1) })
end

--

hi("1468369091346906859060166438166794"):P()
hi("1468369091346906859060166438166794"):n10P()

hi(tbl2src({72; 101; 108; 108; 111; 44; 32; 87; 111; 114; 108; 100; 33; 10})):P()
hi(tbl2src({72; 101; 108; 108; 111; 44; 32; 87; 111; 114; 108; 100; 33; 10})):n10P()
hi(tbl2src(split("72 101 108 108 111 44 32 87 111 114 108 100 33 10", "%d+", tonumber))):P()
hi(tbl2src(split("72 101 108 108 111 44 32 87 111 114 108 100 33 10", "%d+", tonumber))):n10P()
hi(str2src("Hello, World!\n")):P()
hi(str2src("Hello, World!\n")):n10P()
