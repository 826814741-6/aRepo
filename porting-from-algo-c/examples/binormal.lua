--
--  from src/binormal.c
--
--    void binormal_rnd(double, double *, double *)  to  binormalRnd
--

local crnd = require 'rand'.crnd
local binormalRnd = require 'binormal'.binormalRnd

do
	local c = crnd()

	for _=1,20 do
		print(("%10.5f %10.5f"):format(binormalRnd(0.5, c)))
	end
end
