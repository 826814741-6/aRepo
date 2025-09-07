--
--  from src/si.c
--
--    double Si_series(double)  to  seriesExpansion
--    double Si_asympt(double)  to  asymptoticExpansion
--    double Si(double)         to  Si
--

local Si = require 'integral'.Si

do
	print(" x     Si(x)");
	for x=1,50 do
		print(("%2.0f  %.10f"):format(x, Si(x)))
	end
end
