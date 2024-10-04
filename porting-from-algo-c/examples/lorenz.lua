--
--	from src/lorenz.c
--
--	a part of main		to	lorenzAttractor
--

local M0 = require 'svgplot'
local M1 = require 'lorenz'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local lorenzAttractor = M1.lorenzAttractor
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

do
	local sigma, rho, beta, n = 10, 28, 8 / 3, 4000
	local x, y, a1, a2, a3, a4 = 400, 460, 0.01, 10, 200, 40
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	with("results/lorenz-A.svg", "w", function (fh)
		local plotter = svgPlot(x, y)
		plotter:plotStart(fh)
		plotter:pathStart()
		lorenzAttractor(plotter, sigma, rho, beta, n, a1, a2, a3, a4)
		plotter:pathEnd(false, style)
		plotter:plotEnd()
	end)

	with("results/lorenz-B.svg", "w", function (fh)
		extension(svgPlot(x, y))
			:plotStart(fh)
			:pathStart()
			:lorenzAttractor(sigma, rho, beta, n, a1, a2, a3, a4)
			:pathEnd(false, style)
			:plotEnd()
	end)

	withPlotter(
		"results/lorenz-C.svg",
		extension(svgPlot(x, y))
	)(function (plotter)
		plotter
			:pathStart()
			:lorenzAttractor(sigma, rho, beta, n, a1, a2, a3, a4)
			:pathEnd(false, style)
	end)
end
