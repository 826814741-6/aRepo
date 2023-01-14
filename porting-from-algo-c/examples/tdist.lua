--
--	from src/tdist.c
--
--	double p_t(int, double)		to	pT
--	double q_t(int, double)		to	qT
--

local M = require 'distribution'

local pT = M.pT

do
	print("-------- pT(df, t)")
	print(("  t   %-16s %-16s %-16s %-16s"):format(
		"df=1", "df=2", "df=5", "df=20"))
	for i=-10,10 do
		local t = 0.5 * i
		print(("%4.1f %16.14f %16.14f %16.14f %16.14f"):format(
			t, pT(1,t), pT(2,t), pT(5,t), pT(20,t)))
	end
end
