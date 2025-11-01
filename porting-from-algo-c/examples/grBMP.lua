--
--  from src/grBMP.c
--
--    void putbytes(FILE *, int, unsigned long)            to  (string.pack)
--    void gr_dot(int, int, long)                          to  BMP; :dot
--    void gr_clear(long)                                  to  BMP; :clear
--    void gr_BMP(char *)                                  to  BMP; :file(, :write)
--

local M = require 'grBMP'

local BMP, PRESET_COLOR = M.BMP, M.PRESET_COLOR

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:rect(1, x//2 + 1, 1, y//2 + 1, PRESET_COLOR.GREEN)
	bmp:rect(x//2 + 1, x, 1, y//2 + 1, PRESET_COLOR.BLUE)
	bmp:rect(1, x//2 + 1, y//2 + 1, y, PRESET_COLOR.RED)
	bmp:rect(x//2 + 1, x, y//2 + 1, y, PRESET_COLOR.WHITE)

	bmp:file("results/grBMP.bmp")
end
