--
--	from src/normal.c
--
--	double p_nor(double)		to	pNormal
--	double q_nor(double)		to	qNormal
--

local M = require 'distribution'

local pNormal = M.pNormal

do
	print(("%-3s %-16s"):format("z", "pNormal(z)"))
	for i=0,20 do
		local z = 0.2 * i
		print(("%3.1f %16.14f"):format(z, pNormal(z)))
	end
end
