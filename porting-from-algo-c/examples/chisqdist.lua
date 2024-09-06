--
--	from src/chi2.c
--
--	double p_nor(double)		to	pNormal
--	double q_nor(double)		to	qNormal
--	double q_chi2(int, double)	to	qChiSquare
--	double p_chi2(int, double)	to	pChiSquare
--

local M = require 'distribution'

local pChiSquare = M.pChiSquare

do
	print("-------- pChiSquare(df, chiSq)")
	print(
		("chiSq  %-16s %-16s %-16s %-16s")
			:format(
				"df=1",
				"df=2",
				"df=5",
				"df=20"
			)
	)

	for i=0,19 do
		local chiSq = 0.5 * i;
		print(
			("%4.1f %16.14f %16.14f %16.14f %16.14f")
				:format(
					chiSq,
					pChiSquare(1, chiSq),
					pChiSquare(2, chiSq),
					pChiSquare(5, chiSq),
					pChiSquare(20, chiSq)
				)
		)
	end
end
