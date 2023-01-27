--
--	from src/julia.c
--
--	a part of main		to	julia
--

local M0 = require 'grBMP'
local M1 = require 'julia'

local BMP, PRESET_COLORS = M0.BMP, M0.PRESET_COLORS
local julia = M1.julia

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

	local fh = io.open("results/julia.bmp", "w")
	bmp:write(fh)
	fh:close()
end
