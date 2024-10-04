--
--	from src/ccurve.c
--
--	void c(int, double, double)	to	cCurve
--

local M0 = require 'svgplot'
local M1 = require 'ccurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local cCurve = M1.cCurve
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, style)
	local plotter = extension(svgPlot(400, 250))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			plotter:move(100, 200)
			cCurve(plotter, n, 200, 0)
			plotter:pathEnd(false, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:move(100, 200)
				:cCurve(n, 200, 0)
				:pathEnd(false, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:move(100, 200)
				:cCurve(n, 200, 0)
				:pathEnd(false, style)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/ccurve", style)

	for n=1,10 do
		writer(n)
	end
end
