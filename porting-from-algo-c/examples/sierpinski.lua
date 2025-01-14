--
--	from src/sierpin.c
--
--	void urd(int)		to	sierpinski; urd
--	void lur(int)		to	sierpinski; lur
--	void dlu(int)		to	sierpinski; dlu
--	void rdl(int)		to	sierpinski; rdl
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local sierpinski = require 'sierpinski'.sierpinski
local with = require '_helper'.with

local function sampleWriter(pathPrefix, size, offset, style)
	local m = size + offset
	return function (n)
		function body(plotter)
			plotter:pathStart()
			sierpinski(plotter, n, size)
			plotter:pathEnd(true, style)
		end

		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlot(m, m):write(fh, body)
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWholeBuffer(m, m):write(fh, body):reset()
		end)

		with(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWithBuffer(m, m):write(fh, body)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/sierpinski", 600, 2, style)

	for n=1,6 do
		writer(n)
	end
end
