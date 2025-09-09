--
--  from src/bifur.c
--
--    a part of main  to  bifur
--

local M = require 'grBMP'

local BMP, BLACK, WHITE = M.BMP, M.PRESET_COLORS.BLACK, M.PRESET_COLORS.WHITE
local bifur = require 'bifur'.bifur
local file = require '_helper'.file

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	local kmin, kmax, pmin, pmax = 1.5, 3, 0, 1.5
	bifur(bmp, BLACK, WHITE, x, kmin, kmax, pmin, pmax)

	file("results/bifur.bmp", "wb", function (fh)
		bmp:write(fh)
	end)
end
