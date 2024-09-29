--
--	from src/lissaj.c
--
--	a part of main		to	lissajousCurve
--

local M0 = require 'svgplot'
local M1 = require 'lissajouscurve'
local H = require '_helper'

local svgPlot = M0.svgPlot
local svgPlotWholeBuffer = M0.svgPlotWholeBuffer
local svgPlotWithBuffer = M0.svgPlotWithBuffer
local lissajousCurve = M1.lissajousCurve
local extension = M1.extension
local with = H.with

local n, offset = 300, 10

do
	with("results/lissajouscurve-A.svg", "w", function (fh)
		local plotter = svgPlot((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh)
		plotter:pathStart()
		lissajousCurve(plotter, n, offset)
		plotter:pathEnd()
		plotter:plotEnd()
	end)

	with("results/lissajouscurve-B.svg", "w", function (fh)
		extension(svgPlot((n + offset) * 2, (n + offset) * 2))
			:plotStart(fh)
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd()
			:plotEnd()
	end)
end

do
	local plotter = svgPlotWholeBuffer((n + offset) * 2, (n + offset) * 2)

	plotter:pathStart()
	lissajousCurve(plotter, n, offset)
	plotter:pathEnd()

	with("results/lissajouscurve-WB-A-A.svg", "w", function (fh)
		plotter:write(fh)
	end)

	plotter:reset()

	extension(plotter)
		:pathStart()
		:lissajousCurve(n, offset)
		:pathEnd()

	with("results/lissajouscurve-WB-A-B.svg", "w", function (fh)
		plotter:write(fh)
	end)
end

do
	with("results/lissajouscurve-WB-B-A.svg", "w", function (fh)
		local plotter = svgPlotWithBuffer((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh, 30)
		plotter:pathStart()
		lissajousCurve(plotter, n, offset)
		plotter:pathEnd()
		plotter:plotEnd()
	end)

	with("results/lissajouscurve-WB-B-B.svg", "w", function (fh)
		extension(svgPlotWithBuffer((n + offset) * 2, (n + offset) * 2))
			:plotStart(fh, 30)
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd()
			:plotEnd()
	end)
end
