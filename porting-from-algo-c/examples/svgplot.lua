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
--						to	svgPlotWholeBuffering
--						to	svgPlotWithBuffering
--

local M = require 'svgplot'
local H = require '_helper'

local svgPlot = M.svgPlot
local svgPlotWholeBuffering = M.svgPlotWholeBuffering
local svgPlotWithBuffering = M.svgPlotWithBuffering
local with = H.with

local PI, m_cos, m_sin = math.pi, math.cos, math.sin

function sample(plotter)
	for i=0,4 do
		local theta = 2 * PI * i / 5
		local x, y = 150 + 140 * m_cos(theta), 150 + 140 * m_sin(theta)
		if i == 0 then
			plotter:move(x, y)
		else
			plotter:draw(x, y)
		end
	end
end

function extension(T)
	function T:sample()
		sample(T)
		return T
	end
	return T
end

do
	with("results/svgplot-A.svg", "w", function (fh)
		local plotter = svgPlot(300, 300)
		plotter:plotStart(fh)
		plotter:pathStart()
		sample(plotter)
		plotter:pathEnd(true)
		plotter:plotEnd()
	end)

	with("results/svgplot-B.svg", "w", function (fh)
		extension(svgPlot(300, 300))
			:plotStart(fh)
			:pathStart(fh)
			:sample()
			:pathEnd(true)
			:plotEnd()
	end)
end

do
	local plotter = svgPlotWholeBuffering(300, 300)

	plotter:pathStart()
	sample(plotter)
	plotter:pathEnd(true)

	with("results/svgplot-WB-A-A.svg", "w", function (fh)
		plotter:writeOneByOne(fh)
	end)

	plotter:reset()

	extension(plotter)
		:pathStart()
		:sample()
		:pathEnd(true)

	with("results/svgplot-WB-A-B.svg", "w", function (fh)
		plotter:writeOneByOne(fh)
	end)
end

do
	with("results/svgplot-WB-B-A.svg", "w", function (fh)
		local plotter = svgPlotWithBuffering(300, 300)
		plotter:plotStart(fh, 2)
		plotter:pathStart()
		sample(plotter)
		plotter:pathEnd(true)
		plotter:plotEnd()
	end)

	with("results/svgplot-WB-B-B.svg", "w", function (fh)
		extension(svgPlotWithBuffering(300, 300))
			:plotStart(fh, 2)
			:pathStart()
			:sample()
			:pathEnd(true)
			:plotEnd()
	end)
end
