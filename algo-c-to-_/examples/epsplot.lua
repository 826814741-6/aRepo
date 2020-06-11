--
--	from src/epsplot.c
--
--	void plot_start(int, int)		to	epsPlot; :plotStart
--	void plot_end(int)			to	epsPlot; :plotEnd
--	void move(double, double)		to	epsPlot; :move
--	void move_rel(double, double)		to	epsPlot; :moveRel
--	void draw(double, double)		to	epsPlot; :draw
--	void draw_rel(double, double)		to	epsPlot; :drawRel
--

local M = require 'epsplot'

local epsPlot = M.epsPlot
local pi, cos, sin = math.pi, math.cos, math.sin

function sample(plotter, fh)
	plotter:plotStart(fh) -- ...:plotStart(); write to io.stdout
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
	local plotter = epsPlot(300, 300)

	local fh = io.open("results/epsplot.eps", "w")
	local ret = pcall(sample, plotter, fh)
	fh:close()

	assert(ret == true)
end
