--
--  from src/binormal.c
--
--    void binormal_rnd(double, double *, double *)  to  binormalRnd
--

local M = require 'grBMP'

local BMP, BLACK, WHITE = M.BMP, M.PRESET_COLOR.BLACK, M.PRESET_COLOR.WHITE
local samplePlotter = require 'binormal'.samplePlotter
local crnd = require 'crnd'.crnd
local file = require '_helper'.file

do
	local x, y = 600, 600
	local plotter = samplePlotter(x, y, 100, BLACK, WHITE)
	local bmp, c = BMP(x, y), crnd(12345)

	function body(fh) bmp:write(fh) end

	plotter(bmp, c, 100000, 0.5)

	file("results/binormal5.bmp", "wb", body)

	plotter(bmp, c, 100000, -0.5)

	file("results/binormal5N.bmp", "wb", body)

	plotter(bmp, c, 100000, 0.9)

	file("results/binormal9.bmp", "wb", body)

	plotter(bmp, c, 100000, -0.9)

	file("results/binormal9N.bmp", "wb", body)
end
