--
--  from src/binormal.c
--
--    void binormal_rnd(double, double *, double *)  to  binormalRnd
--

local M = require 'grBMP'

local BMP, BLACK, WHITE = M.BMP, M.PRESET_COLOR.BLACK, M.PRESET_COLOR.WHITE
local samplePlotter = require 'binormal'.samplePlotter
local crnd = require 'rand'.crnd

do
	local x, y = 600, 600
	local plotter = samplePlotter(x, y, 100, BLACK, WHITE)
	local bmp, c = BMP(x, y), crnd(12345)

	plotter(bmp, c, 100000, 0.5)
	bmp:file("results/binormal5.bmp")

	plotter(bmp, c, 100000, -0.5)
	bmp:file("results/binormal5N.bmp")

	plotter(bmp, c, 100000, 0.9)
	bmp:file("results/binormal9.bmp")

	plotter(bmp, c, 100000, -0.9)
	bmp:file("results/binormal9N.bmp")
end
