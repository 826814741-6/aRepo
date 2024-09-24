--
--	from src/dragon.c
--
--	void dragon(int, double, double, int)	to	dragonCurveR
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local dragonCurveR = M1.dragonCurveR
local extension = M1.extension
local with = H.with

function sampleWriter(pathPrefix, x, y, dx, dy, sign, x0, y0)
	local plotter = extension(svgPlot(x, y))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			dragonCurveR(plotter, n, dx, dy, sign, x0, y0)
			plotter:pathEnd()
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:dragonCurveR(n, dx, dy, sign, x0, y0)
				:pathEnd()
				:plotEnd()
		end)
	end
end

do
	local x, y, dx, dy = 400, 250, 200, 0

	local writer = sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100)

	for n=1,10 do
		writer(n)
	end

	sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100)(12)
	sampleWriter("results/dragoncurveRN", x, y, dx, dy, -1, 70, 160)(12)
end
