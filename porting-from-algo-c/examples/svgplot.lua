--
--	from src/svgplot.c
--
--	void plot_start(int, int)		to	svgPlot; :plotStart, :pathStart
--	void plot_end(int)			to	svgPlot; :plotEnd, :pathEnd
--	void move(double, double)		to	svgPlot; :move
--	void move_rel(double, double)		to	svgPlot; :moveRel
--	void draw(double, double)		to	svgPlot; :draw
--	void draw_rel(double, double)		to	svgPlot; :drawRel
--
--						to	svgPlotWholeBuffer
--						to	svgPlotWithBuffer
--

local M = require 'svgplot'
local H = require '_helper'

local mustBePlotter = M.mustBePlotter
local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local with = H.with
local withPlotter = H.withPlotter

local PI, m_cos, m_sin = math.pi, math.cos, math.sin

local function sample(plotter, n, offset)
	for i=0,4 do
		local theta = 2 * PI * i / 5
		local x, y =
			n / 2 + (n / 2 - offset) * m_cos(theta),
			n / 2 + (n / 2 - offset) * m_sin(theta)
		if i == 0 then
			plotter:move(x, y)
		else
			plotter:draw(x, y)
		end
	end
end

local function extension(T)
	mustBePlotter(T)
	function T:sample(n, offset)
		sample(T, n, offset)
		return T
	end
	return T
end

local size, offset = 300, 10
local styleA, styleB, styleC =
	styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get(),
	styleMaker()
		:fill(SV.None)
		:stroke(SV.RandomRGB)
		:strokeWidth(5)
		:get(),
	styleMaker()
		:fill(SV.RandomRGB)
		:stroke(SV.RandomRGB)
		:strokeWidth(10)
		:get()

do
	with("results/svgplot-A.svg", "w", function (fh)
		local plotter = svgPlot(size, size)
		plotter:plotStart(fh)
		plotter:pathStart()
		sample(plotter, size, offset)
		plotter:pathEnd(true, styleA)
		plotter:plotEnd()
	end)

	with("results/svgplot-B.svg", "w", function (fh)
		extension(svgPlot(size, size))
			:plotStart(fh)
			:pathStart()
			:sample(size, offset)
			:pathEnd(true, styleB)
			:plotEnd()
	end)

	withPlotter(
		"results/svgplot-C.svg",
		extension(svgPlot(size, size))
	)(function (plotter)
		plotter
			:pathStart()
			:sample(size, offset)
			:pathEnd(true, styleC)
	end)
end

do
	local plotter = svgPlotWholeBuffer(size, size)

	plotter:pathStart()
	sample(plotter, size, offset)
	plotter:pathEnd(true, styleA)

	with("results/svgplot-WB-A-A.svg", "w", function (fh)
		plotter:writeOneByOne(fh)
	end)

	plotter:reset()

	extension(plotter)
		:pathStart()
		:sample(size, offset)
		:pathEnd(true, styleB)

	with("results/svgplot-WB-A-B.svg", "w", function (fh)
		plotter:writeOneByOne(fh)
	end)

	plotter:reset()

	withPlotter(
		"results/svgplot-WB-A-C.svg",
		plotter,
		true
	)(function (plotter)
		plotter
			:pathStart()
			:sample(size, offset)
			:pathEnd(true, styleC)
	end)
end

do
	with("results/svgplot-WB-B-A.svg", "w", function (fh)
		local plotter = svgPlotWithBuffer(size, size)
		plotter:plotStart(fh, 2)
		plotter:pathStart()
		sample(plotter, size, offset)
		plotter:pathEnd(true, styleA)
		plotter:plotEnd()
	end)

	with("results/svgplot-WB-B-B.svg", "w", function (fh)
		extension(svgPlotWithBuffer(size, size))
			:plotStart(fh, 2)
			:pathStart()
			:sample(size, offset)
			:pathEnd(true, styleB)
			:plotEnd()
	end)

	withPlotter(
		"results/svgplot-WB-B-C.svg",
		extension(svgPlotWithBuffer(size, size)),
		2
	)(function (plotter)
		plotter
			:pathStart()
			:sample(size, offset)
			:pathEnd(true, styleC)
	end)
end
