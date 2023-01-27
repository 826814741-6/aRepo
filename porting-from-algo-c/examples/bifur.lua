--
--	from src/bifur.c
--
--	a part of main		to	bifur
--

local M0 = require 'grBMP'
local M1 = require 'bifur'

local BMP, PRESET_COLORS = M0.BMP, M0.PRESET_COLORS
local bifur = M1.bifur

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	local kmin, kmax, pmin, pmax = 1.5, 3, 0, 1.5
	bifur(bmp, PRESET_COLORS.BLACK, PRESET_COLORS.WHITE, x, kmin, kmax, pmin, pmax)

	local fh = io.open("results/bifur.bmp", "w")
	bmp:write(fh)
	fh:close()
end
