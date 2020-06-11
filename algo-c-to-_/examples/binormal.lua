--
--	from src/ binormal.c
--
--	void binormal_rnd(double, double *, double *)	to	binormalRnd
--

local M0 = require 'crnd'
local M1 = require 'binormal'

local crnd = M0.crnd
local binormalRnd = M1.binormalRnd

do
	local c = crnd()

	for _=1,20 do
		print(("%10.5f %10.5f"):format(binormalRnd(0.5, c)))
	end
end
