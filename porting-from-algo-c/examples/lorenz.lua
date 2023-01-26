--
--	from src/lorenz.c
--
--	a part of main		to	lorenzAttractor
--

local M0 = require 'svgplot'
local M1 = require 'lorenz'
local H = require '_helper'

local svgPlot = M0.svgPlot
local lorenzAttractor = M1.lorenzAttractor
local fileWriter = H.fileWriter

local sigma, rho, beta, n = 10, 28, 8 / 3, 4000
local x, y, a1, a2, a3, a4 = 400, 460, 0.01, 10, 200, 40

do
	fileWriter("results/lorenz.svg", "w", function (fh)
		local plotter = svgPlot(x, y)
		plotter:plotStart(fh)
		lorenzAttractor(plotter, sigma, rho, beta, n, a1, a2, a3, a4)
		plotter:plotEnd()
	end)
end
