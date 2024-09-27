--
--	from src/zeta.c
--
--	double zeta(double)	to	riemannZeta
--

local riemannZeta = require 'zeta'.riemannZeta

do
	local zeta = riemannZeta()

	for x=-4,0 do
		print(("zeta(%2d) : %.15f"):format(x, zeta(x)))
	end

	print()

	for x=2,20 do
		print(("zeta(%2d) : %.15f"):format(x, zeta(x)))
	end
end
