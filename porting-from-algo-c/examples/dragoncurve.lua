--
--	from src/dragon2.c
--
--	a part of main				to	dragonCurve
--

local M0 = require 'svgplot'
local M1 = require 'dragoncurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local dragonCurve = M1.dragonCurve
local fileWriter = H.fileWriter

function sampleWriter(pathPrefix, x, y, x0, y0)
	local plotter = svgPlot(x, y)

	return function (n)
		fileWriter(("%s%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			dragonCurve(plotter, n, x0, y0)
			plotter:plotEnd()
		end)
	end
end

do
	local x, y, x0, y0 = 510, 350, 120, 120

	local writer = sampleWriter("results/dragoncurve", x, y, x0, y0)

	for n=1,10 do
		writer(n)
	end
end
