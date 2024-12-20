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

local fSqrt, fSqrtM, iSqrt = M.fSqrt, M.fSqrtM, M.iSqrt

local function _t_iSqrt(l, r)
	for i=l,r-1 do
		local t = iSqrt(i)
		if t * t > i or (t+1) * (t+1) <= i then
			error(("ERROR: (i, t) is (%d, %d)"):format(i, t))
		end
	end
	print(("iSqrt() seems to be fine in %d to %d-1."):format(l, r))
end

do
	for i=0,20 do
		print(
			("math.sqrt(%d)\t%.20f\nfSqrt(%d)\t%.20f (%q)")
				:format(
					i,
					math.sqrt(i),
					i,
					fSqrt(i),
					math.sqrt(i) == fSqrt(i)
				)
		)
		if fSqrtM ~= nil then
			print(("fSqrtM(%d,%d)\t%s"):format(i, 50, fSqrtM(i, 50)))
		end
	end

	print("--")

	-- _t_iSqrt(0, 1 << 32) -- Maybe this will take a lot of time.
	_t_iSqrt(0, 1 << 16)
end
