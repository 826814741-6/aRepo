--
--	from src/dragon2.c
--
--	a part of main				to	dragonCurve
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'

local svgPlot = M0.svgPlot
local dragonCurve = M1.dragonCurve

function sampleWriter(pathPrefix, x, y, x0, y0)
	local plotter = svgPlot(x, y)

	function sample(order)
		plotter:reset()

		plotter:plotStart()
		dragonCurve(plotter, order, x0, y0)
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
	local x, y, x0, y0 = 510, 350, 120, 120

	local writer = sampleWriter("results/dragoncurve", x, y, x0, y0)

	for n=1,10 do writer(n) end
end
