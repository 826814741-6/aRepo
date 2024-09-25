--
--	from src/grBMP.c
--
--	void putbytes(FILE *, int, unsigned long)	to	(string.pack)
--	void gr_dot(int, int, long)			to	BMP; :dot
--	void gr_clear(long)				to	BMP; :rect, :clear
--	void gr_BMP(char *)				to	BMP; :write
--

local M = require 'grBMP'

local BMP, PRESET_COLORS = M.BMP, M.PRESET_COLORS

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:rect(1, x//2 + 1, 1, y//2 + 1, PRESET_COLORS.GREEN)
	bmp:rect(x//2 + 1, x, 1, y//2 + 1, PRESET_COLORS.BLUE)
	bmp:rect(1, x//2 + 1, y//2 + 1, y, PRESET_COLORS.RED)
	bmp:rect(x//2 + 1, x, y//2 + 1, y, PRESET_COLORS.WHITE)

	local fh = io.open("results/grBMP.bmp", "wb")
	bmp:write(fh)
	fh:close()
end
