--
--  from src/lorenz.c
--
--    a part of main  to  lorenzAttractor
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local lorenzAttractor = require 'lorenz'.lorenzAttractor
local with = require '_helper'.with

do
	local sigma, rho, beta, n = 10, 28, 8 / 3, 4000
	local x, y, a1, a2, a3, a4 = 400, 460, 0.01, 10, 200, 40
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	function body(plotter)
		plotter:pathStart()
		lorenzAttractor(plotter, sigma, rho, beta, n, a1, a2, a3, a4)
		plotter:pathEnd(false, style)
	end

	with("results/lorenz-A.svg", "w", function (fh)
		svgPlot(x, y):write(fh, body)
	end)

	with("results/lorenz-B.svg", "w", function (fh)
		svgPlotWholeBuffer(x, y):write(fh, body):reset()
	end)

	with("results/lorenz-C.svg", "w", function (fh)
		svgPlotWithBuffer(x, y):write(fh, body)
	end)
end
