--
--	from src/line.c
--
--	void gr_line(int, int, int, int, long)		to	BMP; :line
--

local M = require 'grBMP'
local H = require 'rand'

local BMP, PRESETCOLORS, makeColor = M.BMP, M.PRESETCOLORS, M.makeColor
local RAND = H.RAND

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:clear(PRESETCOLORS.BLACK)

	local r = RAND()
	for _=1,100 do
		bmp:line(
			r:rand() % x,
			r:rand() % y,
			r:rand() % x,
			r:rand() % y,
			makeColor(r:randRaw() % (0xffffff + 1))
		)
	end

	local fh = io.open("results/line.bmp", "w")
	bmp:write(fh)
	fh:close()
end
