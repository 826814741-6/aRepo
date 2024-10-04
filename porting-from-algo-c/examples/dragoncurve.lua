--
--	from src/dragon2.c
--
--	a part of main				to	dragonCurve
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local dragonCurve = M1.dragonCurve
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, x, y, x0, y0, style)
	local plotter = extension(svgPlot(x, y))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			dragonCurve(plotter, n, x0, y0)
			plotter:pathEnd(false, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:dragonCurve(n, x0, y0)
				:pathEnd(false, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:dragonCurve(n, x0, y0)
				:pathEnd(false, style)
		end)
	end
end

do
	local x, y, x0, y0 = 510, 350, 120, 120
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/dragoncurve", x, y, x0, y0, style)

	for n=1,10 do
		writer(n)
	end
end
