--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treeCurve
--

local M0 = require 'svgplot'
local M1 = require 'treecurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local treeCurve = M1.treeCurve
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, style)
	local plotter = extension(svgPlot(400, 350))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			plotter:move(200, 0)
			treeCurve(plotter, n, 100, 0, 0.7, 0.5)
			plotter:pathEnd(false, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:move(200, 0)
				:treeCurve(n, 100, 0, 0.7, 0.5)
				:pathEnd(false, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:move(200, 0)
				:treeCurve(n, 100, 0, 0.7, 0.5)
				:pathEnd(false, style)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/treecurve", style)

	for n=1,10 do
		writer(n)
	end
end
