--
--	from src/svgplot.c
--
--	void plot_start(int, int)		to	svgPlot; :plotStart
--	void plot_end(int)			to	svgPlot; :plotEnd
--	void move(double, double)		to	svgPlot; :move
--	void move_rel(double, double)		to	svgPlot; :moveRel
--	void draw(double, double)		to	svgPlot; :draw
--	void draw_rel(double, double)		to	svgPlot; :drawRel
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local pi, cos, sin = math.pi, math.cos, math.sin

function sample(plotter)
	plotter:plotStart()
	for i=0,4 do
		local theta = 2 * pi * i / 5
		local x, y = 150 + 140 * cos(theta), 150 + 140 * sin(theta)
		if i == 0 then
			plotter:move(x, y)
		else
			plotter:draw(x, y)
		end
	end
	plotter:plotEnd(true)
end

do
	local plotter = svgPlot(300, 300)

	sample(plotter)

	local fh = io.open("results/svgplot.svg", "w")
	plotter:write(fh)
	fh:close()
end
