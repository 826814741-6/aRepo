--
--	from src/gasket.c
--
--	triangle and a part of main	to	sierpinskiGasket
--

local M0 = require 'grBMP'
local M1 = require 'sierpinski'

local BMP, PRESETCOLORS = M0.BMP, M0.PRESETCOLORS
local sierpinskiGasket = M1.sierpinskiGasket

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	local n = 65
	sierpinskiGasket(bmp, n, PRESETCOLORS.BLACK, PRESETCOLORS.WHITE)

	local fh = io.open("results/gasket.bmp", "w")
	bmp:write(fh)
	fh:close()
end
