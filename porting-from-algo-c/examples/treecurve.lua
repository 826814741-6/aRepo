--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treecurve
--

local M0 = require 'svgplot'
local M1 = require 'treecurve'

local svgPlot, treecurve = M0.svgPlot, M1.treecurve

function sampleWriter(pathPrefix)
	local plotter = svgPlot(400, 350)

	function sample(order)
		plotter:reset()

		plotter:plotStart()
		plotter:move(200, 0)
		treecurve(plotter, order, 100, 0, 0.7, 0.5)
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
	local writer = sampleWriter("results/treecurve")

	for n=1,10 do writer(n) end
end
