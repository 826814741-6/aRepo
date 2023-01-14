--
--	from src/power.c
--
--	double ipower(double, int)	to	iPow
--	iPow				to	iPowR
--	double power(double, double)	to	fPow
--

local M = require 'power'

local iPow, iPowR, fPow = M.iPow, M.iPowR, M.fPow

do
	print(("%22s%18s%18s"):format(
		"2^n==iPow(2,n)", "2^n==iPowR(2,n)", "2^n==fPow(2,n)"))

	for n=-10,10 do
		print(("%17s%18s%18s"):format(
			2^n==iPow(2,n), 2^n==iPowR(2,n), 2^n==fPow(2,n)))
	end

	print(("%15s%25s%18s"):format(
		"2^n", "2^n==fPow(2,n)", "fPow(2,n)"))

	for n=-10,10 do
		print(("%25.20f%10s%30.20f"):format(
			2^n, 2^n==fPow(2,n), fPow(2,n)))
	end
end
