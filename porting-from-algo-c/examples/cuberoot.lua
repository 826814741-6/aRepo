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
			error(("ERROR: (i, t) is (%d, %d)"):format(i, t))
		end
	end
	print(("iCbrt() seems to be fine in %d to %d-1."):format(l, r))
end

do
	for i=-10,10 do
		local a, b = fCbrt(i), fCbrt2(i)
		print(
			("%3d % .14f %18.14f %6s (delta: %g) %s")
				:format(
					i,
					a,
					b,
					a == b,
					math.abs(a - b),
					fCbrtM ~= nil and fCbrtM(i, 50) or ""
				)
		)
	end

	print("--")

	-- _t_iCbrt(0, 1 << 32) -- Maybe this will take a lot of time.
	_t_iCbrt(0, 1 << 16)
end
