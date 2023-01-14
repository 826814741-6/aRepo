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

	function sample(fh, order)
		plotter:plotStart(fh)
		plotter:move(100, 200)
		ccurve(plotter, order, 200, 0)
		plotter:plotEnd()
	end

	return function (order)
		local fh = io.open(("%s%d.svg"):format(pathPrefix, order), "w")
		local ret = pcall(sample, fh, order)
		fh:close()
		assert(ret == true)
	end
end

do
	local writer = sampleWriter("results/ccurve")

	for order=1,10 do writer(order) end
end
