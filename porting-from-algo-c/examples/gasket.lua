--
--  from src/gasket.c
--
--    triangle and a part of main  to  sierpinskiGasket
--

local M = require 'grBMP'

local BMP, BLACK, WHITE = M.BMP, M.PRESET_COLOR.BLACK, M.PRESET_COLOR.WHITE
local sierpinskiGasket = require 'sierpinski'.sierpinskiGasket
local file = require '_helper'.file

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	local n = 65
	sierpinskiGasket(bmp, n, BLACK, WHITE)

	file("results/gasket.bmp", "wb", function (fh)
		bmp:write(fh)
	end)
end
