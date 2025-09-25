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

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local Styler = M.Styler
local SV = M.SV
local file = require '_helper'.file

local PI, m_cos, m_sin = math.pi, math.cos, math.sin

function sample(plotter, n, offset)
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

do
	local size, offset = 300, 10

	function gBody(style)
		return function (plotter)
			plotter:pathStart()
			sample(plotter, size, offset)
			plotter:pathEnd(true, style)
		end
	end

	local bodyA, bodyB, bodyC =
		gBody(SV.PRESET_PLAIN),
		gBody(Styler:fill(SV.None):stroke(SV.RandomRGB):strokeWidth(5)()),
		gBody(Styler:fill(SV.RandomRGB):stroke(SV.RandomRGB):strokeWidth(10)())

	local pltA, pltB, pltC =
		SvgPlotA(size, size), SvgPlotB(size, size), SvgPlotC(size, size)

	file("results/svgplot-A-A.svg", "w", function (fh) pltA:write(fh, bodyA) end)
	file("results/svgplot-A-B.svg", "w", function (fh) pltA:write(fh, bodyB) end)
	file("results/svgplot-A-C.svg", "w", function (fh) pltA:write(fh, bodyC) end)

	file("results/svgplot-B-A.svg", "w", function (fh) pltB:write(fh, bodyA):reset() end)
	file("results/svgplot-B-B.svg", "w", function (fh) pltB:write(fh, bodyB):reset() end)
	file("results/svgplot-B-C.svg", "w", function (fh) pltB:write(fh, bodyC):reset() end)

	file("results/svgplot-C-A.svg", "w", function (fh) pltC:write(fh, bodyA, 2) end)
	file("results/svgplot-C-B.svg", "w", function (fh) pltC:write(fh, bodyB, 2) end)
	file("results/svgplot-C-C.svg", "w", function (fh) pltC:write(fh, bodyC, 2) end)
end
