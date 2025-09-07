--
--  from src/lissaj.c
--
--    a part of main  to  lissajousCurve
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local lissajousCurve = require 'lissajouscurve'.lissajousCurve
local with = require '_helper'.with

local n, offset = 300, 10
local style = styleMaker()
	:fill(SV.None)
	:stroke(SV.Black)
	:get()

do
	function body(plotter)
		plotter:pathStart()
		lissajousCurve(plotter, n, offset)
		plotter:pathEnd(false, style)
	end

	local m = (n + offset) * 2

	with("results/lissajouscurve-A.svg", "w", function (fh)
		svgPlot(m, m):write(fh, body)
	end)

	with("results/lissajouscurve-B.svg", "w", function (fh)
		svgPlotWholeBuffer(m, m):write(fh, body):reset()
	end)

	with("results/lissajouscurve-C.svg", "w", function (fh)
		svgPlotWithBuffer(m, m):write(fh, body, 30)
	end)
end
