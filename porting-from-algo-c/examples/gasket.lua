--
--	from src/gasket.c
--
--	triangle and a part of main	to	sierpinskiGasket
--

local M0 = require 'grBMP'
local M1 = require 'sierpinski'

local BMP, BLACK, WHITE = M0.BMP, M0.PRESET_COLORS.BLACK, M0.PRESET_COLORS.WHITE
local sierpinskiGasket = M1.sierpinskiGasket

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	local n = 65
	sierpinskiGasket(bmp, n, BLACK, WHITE)

	local fh = io.open("results/gasket.bmp", "wb")
	bmp:write(fh)
	fh:close()
end
