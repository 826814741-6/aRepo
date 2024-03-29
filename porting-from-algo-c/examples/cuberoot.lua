--
--	from src/cuberoot.c
--
--	double cuberoot(double)		to	fCbrt
--	double cuberoot2(double)	to	fCbrt2
--	fCbrt				to	fCbrtM (depends on lbc(*))
--
--	from src/icubrt.c
--
--	unsigned icubrt(unsigned)	to	iCbrt
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'nthroot'

local fCbrt, fCbrt2, fCbrtM, iCbrt = M.fCbrt, M.fCbrt2, M.fCbrtM, M.iCbrt

local function _t_iCbrt(l, r)
	for i=l,r-1 do
		local t = iCbrt(i)
		if t * t * t > i or (t+1) * (t+1) * (t+1) <= i then
			print(("ERROR: %d %d"):format(i, t))
			os.exit()
		end
	end
	print(("\niCbrt() seems to be fine in %d to %d-1."):format(l, r))
end

do
	for i=-10,10 do
		local t, u, v = fCbrt(i), fCbrt2(i), fCbrtM~=nil and fCbrtM(i,50) or nil
		print(("%3d %.14f %18.14f %6s (delta: %g)%s"):format(
			i, t, u, t == u, math.abs(t-u),
			v == nil and "" or "\n    "..tostring(v)))
	end

	-- _t_iCbrt(0, 1 << 32) -- Maybe this will take a lot of time. (*)
	_t_iCbrt(0, 1 << 16)
end

--
--	*) Please choose a number depending on the purpose and situation.
--
--	e.g. a list of elapsed time - running _t_iCbrt(0, n) on my old cheap laptop
--
--	in luajit, n == 1<<28 (2^28):
--
--		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
--		...
--		iCbrt() seems to be fine in 0 to 268435456-1.
--
--		real    0m49.737s
--		user    0m49.516s
--		sys     0m0.036s
--
--	in luajit, n == 1<<32 (2^32):
--
--		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
--		...
--		iCbrt() seems to be fine in 0 to 4294967296-1.
--
--		real    13m32.873s
--		user    13m33.160s
--		sys     0m0.122s
--
--	in lua, n == 1<<28 (2^28)
--
--		$ time LUA_PATH=src/?.lua lua example/cuberoot.lua
--		...
--		iCbrt() seems to be fine in 0 to 268435456-1.
--
--		real    5m9.958s
--		user    5m9.423s
--		sys     0m0.082s
--
