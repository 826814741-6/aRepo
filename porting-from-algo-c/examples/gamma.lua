--
--	from src/gamma.c
--
--	double loggamma(double)		to	loggamma
--	double gamma(double)		to	gamma
--	double beta(double, double)	to	beta
--

local M = require 'gamma'

local gamma = M.gamma

function p(x) print(("%4.1f  % .15g"):format(x, gamma(x))) end

do
	print("  x       Gamma(x)")

	for x=-5.5,0.5 do p(x) end

	for x=1,5 do p(x) end

	for x=10,30,5 do p(x) end
end
