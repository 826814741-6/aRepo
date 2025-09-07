--
--  Hello, World! in Lua/LuaJIT
--
--  with something like GNU dc's P command:
--  $ dc -e "1468369091346906859060166438166794P"
--  (see https://github.com/826814741-6/aRepo/blob/main/misc/hi.sh)
--
--  depends on lbc-101; https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc
--

local bc = require 'bc'

local bc_new, bc_quotrem, bc_tonumber = bc.new, bc.quotrem, bc.tonumber
local i_write = io.write
local s_char = string.char
local t_concat, t_insert = table.concat, table.insert

function init(src)
	local T = {
		source = bc_new(src);
		candidate = {}
	}

	local n, edge = T.source, bc_new(255)
	while n > edge do
		local q, r = bc_quotrem(n, 256)
		t_insert(T.candidate, 1, s_char(bc_tonumber(r)))
		n = q
	end
	t_insert(T.candidate, 1, s_char(bc_tonumber(n)))

	return T
end

function extends(T)
	function T:P()
		i_write(t_concat(T.candidate))
	end

	function T:n()
		i_write(tostring(T.source))
	end

	function T:n10P()
		i_write(tostring(T.source), "\n")
	end

	return T
end

-- and some utils

function tbl2src(t)
	local r, j, step = bc_new(0), 0, bc_new(256)

	for i=#t,1,-1 do
		r, j = r + t[i] * (step ^ j), j + 1
	end

	return r
end

function split(s, p, f)
	local r = {}

	for e in s:gmatch(p) do
		t_insert(r, f(e))
	end

	return r
end

function str2src(s)
	return tbl2src({ s:byte(1, -1) })
end

--

function demo(s)
	local obj = extends(init(s))
	obj:P()
	obj:n10P()
end

do
	local samples = {
		"1468369091346906859060166438166794";
		tbl2src({72; 101; 108; 108; 111; 44; 32; 87; 111; 114; 108; 100; 33; 10});
		tbl2src(split("72 101 108 108 111 44 32 87 111 114 108 100 33 10", "%d+", tonumber));
		str2src("Hello, World!\n")
	}

	for _,v in ipairs(samples) do
		demo(v)
	end
end
