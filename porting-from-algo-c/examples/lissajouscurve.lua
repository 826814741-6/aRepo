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
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local lissajousCurve = M1.lissajousCurve
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

local n, offset = 300, 10
local style = styleMaker()
	:fill(SV.None)
	:stroke(SV.Black)
	:get()

do
	with("results/lissajouscurve-A.svg", "w", function (fh)
		local plotter = svgPlot((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh)
		plotter:pathStart()
		lissajousCurve(plotter, n, offset)
		plotter:pathEnd(false, style)
		plotter:plotEnd()
	end)

	with("results/lissajouscurve-B.svg", "w", function (fh)
		extension(svgPlot((n + offset) * 2, (n + offset) * 2))
			:plotStart(fh)
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd(false, style)
			:plotEnd()
	end)

	withPlotter(
		"results/lissajouscurve-C.svg",
		extension(svgPlot((n + offset) * 2, (n + offset) * 2))
	)(function (plotter)
		plotter
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd(false, style)
	end)
end

do
	local plotter = svgPlotWholeBuffer((n + offset) * 2, (n + offset) * 2)

	plotter:pathStart()
	lissajousCurve(plotter, n, offset)
	plotter:pathEnd(false, style)

	with("results/lissajouscurve-WB-A-A.svg", "w", function (fh)
		plotter:write(fh)
	end)

	plotter:reset()

	extension(plotter)
		:pathStart()
		:lissajousCurve(n, offset)
		:pathEnd(false, style)

	with("results/lissajouscurve-WB-A-B.svg", "w", function (fh)
		plotter:write(fh)
	end)

	plotter:reset()

	withPlotter(
		"results/lissajouscurve-WB-A-C.svg",
		plotter
	)(function (plotter)
		plotter
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd(false, style)
	end)
end

do
	with("results/lissajouscurve-WB-B-A.svg", "w", function (fh)
		local plotter = svgPlotWithBuffer((n + offset) * 2, (n + offset) * 2)
		plotter:plotStart(fh, 30)
		plotter:pathStart()
		lissajousCurve(plotter, n, offset)
		plotter:pathEnd(false, style)
		plotter:plotEnd()
	end)

	with("results/lissajouscurve-WB-B-B.svg", "w", function (fh)
		extension(svgPlotWithBuffer((n + offset) * 2, (n + offset) * 2))
			:plotStart(fh, 30)
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd(false, style)
			:plotEnd()
	end)

	withPlotter(
		"results/lissajouscurve-WB-B-C.svg",
		extension(svgPlotWithBuffer((n + offset) * 2, (n + offset) * 2)),
		30
	)(function (plotter)
		plotter
			:pathStart()
			:lissajousCurve(n, offset)
			:pathEnd(false, style)
	end)
end
