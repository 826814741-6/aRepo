--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treeCurve
--

local M0 = require 'svgplot'
local M1 = require 'treecurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local treeCurve = M1.treeCurve
local extension = M1.extension
local with = H.with

function sampleWriter(pathPrefix)
	local plotter = extension(svgPlot(400, 350))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			plotter:move(200, 0)
			treeCurve(plotter, n, 100, 0, 0.7, 0.5)
			plotter:pathEnd()
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:move(200, 0)
				:treeCurve(n, 100, 0, 0.7, 0.5)
				:pathEnd()
				:plotEnd()
		end)
	end
end

do
	local writer = sampleWriter("results/treecurve")

	for n=1,10 do
		writer(n)
	end
end
