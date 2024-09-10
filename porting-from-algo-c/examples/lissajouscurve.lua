--
--	from src/lissaj.c
--
--	a part of main		to	lissajousCurve
--

local M0 = require 'svgplot'
local M1 = require 'lissajouscurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local svgPlotWholeBuffering = M0.svgPlotWholeBuffering
local svgPlotWithBuffering = M0.svgPlotWithBuffering
local lissajousCurve = M1.lissajousCurve
local extension = M1.extension
local with = H.with

local n, offset = 300, 10

do
	with("results/lissajouscurve-A.svg", "w", function (fh)
		local plotter = svgPlot((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh)
		lissajousCurve(plotter, n, offset)
		plotter:plotEnd()
	end)

	with("results/lissajouscurve-B.svg", "w", function (fh)
		extension(svgPlot((n + offset) * 2, (n + offset) * 2))
			:plotStart(fh)
			:lissajousCurve(n, offset)
			:plotEnd()
	end)
end

do
	local plotter = svgPlotWholeBuffering((n + offset) * 2, (n + offset) * 2)

	lissajousCurve(plotter, n, offset)
	with("results/lissajouscurve-WB-A-A.svg", "w", function (fh)
		plotter:write(fh)
	end)

	plotter:reset()

	extension(plotter):lissajousCurve(n, offset)
	with("results/lissajouscurve-WB-A-B.svg", "w", function (fh)
		plotter:write(fh)
	end)
end

do
	with("results/lissajouscurve-WB-B-A.svg", "w", function (fh)
		local plotter = svgPlotWithBuffering((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh, 30)
		lissajousCurve(plotter, n, offset)
		plotter:plotEnd()
	end)

	with("results/lissajouscurve-WB-B-B.svg", "w", function (fh)
		extension(svgPlotWithBuffering((n + offset) * 2, (n + offset) * 2))
			:plotStart(fh, 30)
			:lissajousCurve(n, offset)
			:plotEnd()
	end)
end
