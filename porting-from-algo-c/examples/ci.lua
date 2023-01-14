--
--	from src/ci.c
--
--	double Ci_series(double)	to	seriesExpansion
--	double Ci_asympt(double)	to	asymptoticExpansion
--	double Ci(double)		to	Ci
--

local M = require 'integral'

local Ci = M.Ci

do
	print(" x     Ci(x)")
	for x=1,50 do
		print(("%2.0f  %.10f"):format(x, Ci(x)))
	end
end
