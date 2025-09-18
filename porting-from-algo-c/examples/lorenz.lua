--
--  from src/lorenz.c
--
--    a part of main  to  lorenzAttractor
--

local M = require 'svgplot'

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local lorenzAttractor = require 'lorenz'.lorenzAttractor
local file = require '_helper'.file

do
	local sigma, rho, beta, n = 10, 28, 8 / 3, 4000
	local x, y, a1, a2, a3, a4 = 400, 460, 0.01, 10, 200, 40

	function body(plotter)
		plotter:pathStart()
		lorenzAttractor(plotter, sigma, rho, beta, n, a1, a2, a3, a4)
		plotter:pathEnd(false, M.SV.PRESET_PLAIN)
	end

	file("results/lorenz-A.svg", "w", function (fh)
		SvgPlotA(x, y):write(fh, body)
	end)

	file("results/lorenz-B.svg", "w", function (fh)
		SvgPlotB(x, y):write(fh, body):reset()
	end)

	file("results/lorenz-C.svg", "w", function (fh)
		SvgPlotC(x, y):write(fh, body)
	end)
end
