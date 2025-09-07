--
--  from src/sqrt.c
--
--    double mysqrt(double)      to  fSqrt
--    fSqrt                      to  fSqrtM (depends on lbc(*))
--
--  from src/isqrt.c
--
--    unsigned isqrt(unsigned)   to  iSqrt
--
--  from src/cuberoot.c
--
--    double cuberoot(double)    to  fCbrt
--    double cuberoot2(double)   to  fCbrt2
--    fCbrt                      to  fCbrtM (depends on lbc(*))
--
--  from src/icubrt.c
--
--    unsigned icubrt(unsigned)  to  iCbrt
--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'nthroot'

local fSqrt, fSqrtM, iSqrt = M.fSqrt, M.fSqrtM, M.iSqrt
local fCbrt, fCbrt2, fCbrtM, iCbrt = M.fCbrt, M.fCbrt2, M.fCbrtM, M.iCbrt

local function _t_iSqrt(l, r)
	for i=l,r-1 do
		local t = iSqrt(i)
		if t * t > i or (t+1) * (t+1) <= i then
			error(("ERROR: (i, t) is (%d, %d)"):format(i, t))
		end
	end
	print(("iSqrt() seems to be fine in %d to %d-1."):format(l, r))
end

local function _t_iCbrt(l, r)
	for i=l,r-1 do
		local t = iCbrt(i)
		if t * t * t > i or (t+1) * (t+1) * (t+1) <= i then
			error(("ERROR: (i, t) is (%d, %d)"):format(i, t))
		end
	end
	print(("iCbrt() seems to be fine in %d to %d-1."):format(l, r))
end

local function demo()
	for i=0,20 do
		local a, b = math.sqrt(i), fSqrt(i)
		print(("math.sqrt(%d)\t%.20f\nfSqrt(%d)\t%.20f (%q (delta: %g))")
			:format(i, a, i, b, a == b, math.abs(a - b)))
		if fSqrtM ~= nil then
			print(("fSqrtM(%d,%d)\t%s"):format(i, 50, fSqrtM(i, 50)))
		end
	end

	print("--")

	for i=-10,10 do
		local a, b = fCbrt(i), fCbrt2(i)
		print(("fCbrt(%d)\t%.20f\nfCbrt2(%d)\t%.20f (%q (delta: %g))")
			:format(i, a, i, b, a == b, math.abs(a - b)))
		if fCbrtM ~= nil then
			print(("fCbrtM(%d,%d)\t%s"):format(i, 50, fCbrtM(i, 50)))
		end
	end
end

do
	demo()

	print("--")

	-- _t_iSqrt(0, 1 << 32) -- Maybe this will take a lot of time.
	-- _t_iCbrt(0, 1 << 32) -- Maybe this will take a lot of time.
	_t_iSqrt(0, 1 << 16)
	_t_iCbrt(0, 1 << 16)
end
