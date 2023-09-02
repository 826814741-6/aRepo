--
--	from src/sqrt.c
--
--	double mysqrt(double)		to	fSqrt
--	fSqrt				to	fSqrtM (depends on lbc(*))
--
--	from src/isqrt.c
--
--	unsigned isqrt(unsigned)	to	iSqrt
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'nthroot'

local sqrt, fSqrt, fSqrtM, iSqrt = math.sqrt, M.fSqrt, M.fSqrtM, M.iSqrt

local function _t_iSqrt(l, r)
	for i=l,r-1 do
		local t = iSqrt(i)
		if t * t > i or (t+1) * (t+1) <= i then
			print(("ERROR: %d %d"):format(i, t))
			os.exit()
		end
	end
	print(("iSqrt() seems to be fine in %d to %d-1."):format(l, r))
end

do
	for i=0,20 do
		print(("math.sqrt(%d)\t%.18f\nfSqrt(%d)\t%.18f (%q)%s"):format(
			i, sqrt(i), i, fSqrt(i), sqrt(i) == fSqrt(i),
			fSqrtM == nil and "" or
			("\nfSqrtM(%d,%d)\t"):format(i,50)..tostring(fSqrtM(i,50))))
	end

	print()

	-- _t_iSqrt(0, 1 << 32) -- Maybe this will take a lot of time. (*)
	_t_iSqrt(0, 1 << 16)
end

--
--	*) Please choose a number depending on the purpose and situation.
--
--	e.g. a list of elapsed time - running _t_iSqrt(0, n) on my old cheap laptop
--
--	in luajit, n == 1<<28 (2^28):
--
--		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
--		...
--		iSqrt() seems to be fine in 0 to 268435456-1.
--
--		real    0m36.307s
--		user    0m35.889s
--		sys     0m0.015s
--
--	in luajit, n == 1<<32 (2^32):
--
--		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
--		...
--		iSqrt() seems to be fine in 0 to 4294967296-1.
--
--		real    10m0.827s
--		user    10m0.906s
--		sys     0m0.096s
--
--	in lua, n == 1<<28 (2^28)
--
--		$ time LUA_PATH=src/?.lua lua example/sqrt.lua
--		...
--		iSqrt() seems to be fine in 0 to 268435456-1.
--
--		real    4m50.528s
--		user    4m50.730s
--		sys     0m0.021s
--
