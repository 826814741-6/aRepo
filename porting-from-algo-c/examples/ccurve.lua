--
--	from src/ccurve.c
--
--	void c(int, double, double)	to	ccurve
--

local M0 = require 'svgplot'
local M1 = require 'ccurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local ccurve = M1.ccurve
local with = H.with

function sampleWriter(pathPrefix)
	local plotter = svgPlot(400, 250)

	return function (n)
		with(("%s%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:move(100, 200)
			ccurve(plotter, n, 200, 0)
			plotter:plotEnd()
		end)
	end
end

do
	local writer = sampleWriter("results/ccurve")

	for n=1,10 do
		writer(n)
	end
end
