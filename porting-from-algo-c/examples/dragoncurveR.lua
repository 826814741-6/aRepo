--
--	from src/dragon.c
--
--	void dragon(int, double, double, int)	to	dragonCurveR
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'

local svgPlot = M0.svgPlot
local dragonCurveR = M1.dragonCurveR

function sampleWriter(pathPrefix, x, y, dx, dy, sign, x0, y0)
	local plotter = svgPlot(x, y)

	function sample(order)
		plotter:reset()

		plotter:plotStart()
		dragonCurveR(plotter, order, dx, dy, sign, x0, y0)
		plotter:plotEnd()
	end

	return function (n)
		sample(n)

		local fh = io.open(("%s%d.svg"):format(pathPrefix, n), "w")
		plotter:write(fh)
		fh:close()
	end
end

do
	local x, y, dx, dy = 400, 250, 200, 0

	local writer = sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100)
	for n=1,10 do writer(n) end

	sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100)(12)
	sampleWriter("results/dragoncurveRN", x, y, dx, dy, -1, 70, 160)(12)
end
