--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treecurve
--

local M0 = require 'svgplot'
local M1 = require 'treecurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local treecurve = M1.treecurve
local fileWriter = H.fileWriter

function sampleWriter(pathPrefix)
	local plotter = svgPlot(400, 350)

	return function (n)
		fileWriter(("%s%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:move(200, 0)
			treecurve(plotter, n, 100, 0, 0.7, 0.5)
			plotter:plotEnd()
		end)
	end
end

do
	local writer = sampleWriter("results/treecurve")

	for n=1,10 do
		writer(n)
	end
end
