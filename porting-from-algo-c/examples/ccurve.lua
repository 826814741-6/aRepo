--
--	from src/ccurve.c
--
--	void c(int, double, double)	to	ccurve
--

local M0 = require 'svgplot'
local M1 = require 'ccurve'

local svgPlot, ccurve = M0.svgPlot, M1.ccurve

function sampleWriter(pathPrefix)
	local plotter = svgPlot(400, 250)

	function sample(order)
		plotter:reset()

		plotter:plotStart()
		plotter:move(100, 200)
		ccurve(plotter, order, 200, 0)
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
	local writer = sampleWriter("results/ccurve")

	for n=1,10 do writer(n) end
end
