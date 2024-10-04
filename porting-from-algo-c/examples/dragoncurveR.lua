--
--	from src/dragon.c
--
--	void dragon(int, double, double, int)	to	dragonCurveR
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local dragonCurveR = M1.dragonCurveR
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, x, y, dx, dy, sign, x0, y0, style)
	local plotter = extension(svgPlot(x, y))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			dragonCurveR(plotter, n, dx, dy, sign, x0, y0)
			plotter:pathEnd(false, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:dragonCurveR(n, dx, dy, sign, x0, y0)
				:pathEnd(false, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:dragonCurveR(n, dx, dy, sign, x0, y0)
				:pathEnd(false, style)
		end)
	end
end

do
	local x, y, dx, dy = 400, 250, 200, 0
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100, style)

	for n=1,10 do
		writer(n)
	end

	sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100, style)(12)
	sampleWriter("results/dragoncurveRN", x, y, dx, dy, -1, 70, 160, style)(12)
end
