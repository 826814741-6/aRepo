--
--	from src/lorenz.c
--
--	a part of main		to	lorenzAttractor
--

local M0 = require 'svgplot'
local M1 = require 'lorenz'

local svgPlot = M0.svgPlot
local lorenzAttractor = M1.lorenzAttractor

do
	local sigma, rho, beta, n = 10, 28, 8 / 3, 4000
	local x, y, a1, a2, a3, a4 = 400, 460, 0.01, 10, 200, 40

	local plotter = svgPlot(x, y)
	local fh = io.open("results/lorenz.svg", "w")

	plotter:plotStart(fh)
	local ret = pcall(lorenzAttractor, plotter, sigma, rho, beta, n, a1, a2, a3, a4)
	plotter:plotEnd()

	fh:close()
	assert(ret == true)
end
