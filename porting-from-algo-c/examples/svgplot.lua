--
--  from src/svgplot.c
--
--    void plot_start(int, int)             to   :pathStart
--    void plot_end(int)                    to   :pathEnd
--    void move(double, double)             to   :move
--    void move_rel(double, double)         to   :moveRel
--    void draw(double, double)             to   :draw
--    void draw_rel(double, double)         to   :drawRel
--
--                                               :write(, :reset)
--
--    and some extensions for basic shapes  are  :circle, :ellipse, :line, :rect
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local file = require '_helper'.file

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

local size, offset = 300, 10

local function gBody(style)
	return function (plotter)
		plotter:pathStart()
		sample(plotter, size, offset)
		plotter:pathEnd(true, style)
	end
end

local bodyA, bodyB, bodyC =
	gBody(styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()
	),
	gBody(styleMaker()
		:fill(SV.None)
		:stroke(SV.RandomRGB)
		:strokeWidth(5)
		:get()
	),
	gBody(styleMaker()
		:fill(SV.RandomRGB)
		:stroke(SV.RandomRGB)
		:strokeWidth(10)
		:get()
	)

do
	file("results/svgplot-A-A.svg", "w", function (fh)
		svgPlot(size, size):write(fh, bodyA)
	end)

	file("results/svgplot-A-B.svg", "w", function (fh)
		svgPlot(size, size):write(fh, bodyB)
	end)

	file("results/svgplot-A-C.svg", "w", function (fh)
		svgPlot(size, size):write(fh, bodyC)
	end)

	local plotter = svgPlotWholeBuffer(size, size)

	file("results/svgplot-B-A.svg", "w", function (fh)
		plotter:write(fh, bodyA, true):reset()
	end)

	file("results/svgplot-B-B.svg", "w", function (fh)
		plotter:write(fh, bodyB, true):reset()
	end)

	file("results/svgplot-B-C.svg", "w", function (fh)
		plotter:write(fh, bodyC, true):reset()
	end)

	file("results/svgplot-C-A.svg", "w", function (fh)
		svgPlotWithBuffer(size, size):write(fh, bodyA, 2)
	end)

	file("results/svgplot-C-B.svg", "w", function (fh)
		svgPlotWithBuffer(size, size):write(fh, bodyB, 2)
	end)

	file("results/svgplot-C-C.svg", "w", function (fh)
		svgPlotWithBuffer(size, size):write(fh, bodyC, 2)
	end)
end
