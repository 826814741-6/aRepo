--
--	from src/dragon2.c
--
--	a part of main				to	dragonCurve
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'

local svgPlot = M0.svgPlot
local dragonCurve = M1.dragonCurve

function sampleWriter(pathPrefix, x, y)
	local plotter = svgPlot(x, y)

	function sample(fh, order, x0, y0)
		plotter:plotStart(fh)
		dragonCurve(plotter, order, x0, y0)
		plotter:plotEnd()
	end

	return function (order, x0, y0)
		local fh = io.open(("%s%d.svg"):format(pathPrefix, order), "w")
		local ret = pcall(sample, fh, order, x0, y0)
		fh:close()
		assert(ret == true)
	end
end

do
	local x, y, x0, y0 = 510, 350, 120, 120

	local writer = sampleWriter("results/dragoncurve", x, y)

	for order=1,10 do writer(order, x0, y0) end
end
