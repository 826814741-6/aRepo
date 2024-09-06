--
--	from src/fft.c
--
--	void make_sintbl(int, double [])	to	makeSinTable
--	void make_bitrev(int, int [])		to	makeBitReverseTable
--	int fft(int, double [], double [])	to	cooleyTukey
--

local M = require 'fft'

local cooleyTukey = M.cooleyTukey

local sin, cos = math.sin, math.cos
local PI = math.pi

function sample(n, fA, fB)
	local a, b = {}, {}
	for i=0,n-1 do
		a[i], b[i] = fA(n, i), fB(n, i)
	end
	return a, b
end

function copySample(n, sourceA, sourceB, targetA, targetB)
	for i=0,n-1 do
		targetA[i], targetB[i] = sourceA[i], sourceB[i]
	end
end

function p(n, a0, b0, a1, b1, a2, b2)
	print("      source          fft             inverse")
	for i=0,n-1 do
		print(
			("%4d | %6.3f %6.3f | %6.3f %6.3f | %6.3f %6.3f")
				:format(
					i,
					a0[i],
					b0[i],
					a1[i],
					b1[i],
					a2[i],
					b2[i]
				)
		)
	end
end

do
	local n = 64
	local fft = cooleyTukey(n)

	local x0, y0 = sample(
		n,
		function (n, i) return 6 * cos(6*PI*i/n) + 4 * sin(18*PI*i/n) end,
		function () return 0 end
	)
	local x1, y1, x2, y2 = {}, {}, {}, {}
	
	copySample(n, x0, y0, x1, y1)
	fft(x1, y1)

	copySample(n, x1, y1, x2, y2)
	fft(x2, y2, true)

	p(n, x0, y0, x1, y1, x2, y2)
end
