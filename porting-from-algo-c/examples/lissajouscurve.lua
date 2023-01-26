--
--	from src/lissaj.c
--
--	a part of main		to	lissajousCurve
--

local M0 = require 'svgplot'
local M1 = require 'lissajouscurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local svgPlotWithBuffering = M0.svgPlotWithBuffering
local lissajousCurve = M1.lissajousCurve
local with = H.with

local n, offset = 300, 10

do
	with("results/lissajouscurve.svg", "w", function (fh)
		local plotter = svgPlot((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh)
		lissajousCurve(plotter, n, offset)
		plotter:plotEnd()
	end)
end

do
	local plotter = svgPlotWithBuffering((n + offset) * 2, (n + offset) * 2)
	lissajousCurve(plotter, n, offset)
	with("results/lissajouscurve-WB.svg", "w", function (fh)
		plotter:write(fh)
	end)
end
