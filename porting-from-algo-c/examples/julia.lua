--
--	from src/julia.c
--
--	a part of main		to	julia
--

local M0 = require 'grBMP'
local M1 = require 'julia'

local BMP, PRESETCOLORS = M0.BMP, M0.PRESETCOLORS
local julia = M1.julia

do
	local x, y = 600, 600
	local bmp = BMP(x, y)

	julia(
		bmp,
		x,
		y,
		PRESETCOLORS.RED,
		PRESETCOLORS.GREEN,
		PRESETCOLORS.BLUE,
		PRESETCOLORS.WHITE
	)

	local fh = io.open("results/julia.bmp", "w")
	bmp:write(fh)
	fh:close()
end
