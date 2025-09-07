--
--  from src/binormal.c
--
--    void binormal_rnd(double, double *, double *)  to  binormalRnd
--

local M0 = require 'crnd'
local M1 = require 'binormal'
local M2 = require 'grBMP'

local crnd = M0.crnd
local samplePlotter = M1.samplePlotter
local BMP, BLACK, WHITE = M2.BMP, M2.PRESET_COLORS.BLACK, M2.PRESET_COLORS.WHITE

do
	local x, y = 600, 600
	local plotter = samplePlotter(x, y, 100, BLACK, WHITE)
	local bmp, c = BMP(x, y), crnd(12345)

	plotter(bmp, c, 100000, 0.5)

	local fh = io.open("results/binormal5.bmp", "wb")
	bmp:write(fh)
	fh:close()

	plotter(bmp, c, 100000, -0.5)

	local fh = io.open("results/binormal5N.bmp", "wb")
	bmp:write(fh)
	fh:close()

	plotter(bmp, c, 100000, 0.9)

	local fh = io.open("results/binormal9.bmp", "wb")
	bmp:write(fh)
	fh:close()

	plotter(bmp, c, 100000, -0.9)

	local fh = io.open("results/binormal9N.bmp", "wb")
	bmp:write(fh)
	fh:close()
end
