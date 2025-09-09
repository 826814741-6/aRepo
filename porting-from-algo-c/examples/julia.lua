--
--  from src/julia.c
--
--    a part of main  to  julia
--

local M = require 'grBMP'

local BMP, PRESET_COLORS = M.BMP, M.PRESET_COLORS
local julia = require 'julia'.julia
local file = require '_helper'.file

do
	local x, y = 600, 600
	local bmp = BMP(x, y)

	julia(
		bmp,
		x,
		y,
		PRESET_COLORS.RED,
		PRESET_COLORS.GREEN,
		PRESET_COLORS.BLUE,
		PRESET_COLORS.WHITE
	)

	file("results/julia.bmp", "wb", function (fh)
		bmp:write(fh)
	end)
end
