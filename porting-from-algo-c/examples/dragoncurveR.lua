--
--	from src/dragon.c
--
--	void dragon(int, double, double, int)	to	dragonCurveR
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'

local svgPlot = M0.svgPlot
local dragonCurveR = M1.dragonCurveR

function sampleWriter(pathPrefix, x, y)
	local plotter = svgPlot(x, y)

	function sample(fh, order, dx, dy, sign, x0, y0)
		plotter:plotStart(fh)
		dragonCurveR(plotter, order, dx, dy, sign, x0, y0)
		plotter:plotEnd()
	end

	return function (order, dx, dy, sign, x0, y0)
		local fh = io.open(("%s%d.svg"):format(pathPrefix, order), "w")
		local ret = pcall(sample, fh, order, dx, dy, sign, x0, y0)
		fh:close()
		assert(ret == true)
	end
end

do
	local x, y, dx, dy = 400, 250, 200, 0

	local writer = sampleWriter("results/dragoncurveR", x, y)

	for order=1,10 do writer(order, dx, dy, 1, 100, 100) end

	sampleWriter("results/dragoncurveR", x, y)(12, dx, dy, 1, 100, 100)
	sampleWriter("results/dragoncurveRN", x, y)(12, dx, dy, -1, 70, 160)
end
