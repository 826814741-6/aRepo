--
--  from src/dragon.c
--
--    void dragon(int, double, double, int)  to  dragonCurveR
--

local M = require 'svgplot'

local dragonCurve = require 'dragoncurve'.dragonCurve
local file = require '_helper'.file

function gBody(n, dx, dy, sign, x0, y0)
	return function (plotter)
		plotter:pathStart()
		dragonCurve(plotter, n, dx, dy, sign, x0, y0)
		plotter:pathEnd(false, M.SV.PRESET_PLAIN)
	end
end

do
	local x, y, dx, dy = 400, 250, 200, 0

	local plt = M.SvgPlot(x, y)

	local pathPrefix = "results/dragoncurve"

	file(("%s-A.svg"):format(pathPrefix), "w", function (fh)
		plt:write(fh, gBody(10, dx, dy, 1, 100, 100))
	end)

	file(("%s-B.svg"):format(pathPrefix), "w", function (fh)
		plt:write(fh, gBody(12, dx, dy, -1, 70, 160))
	end)
end
