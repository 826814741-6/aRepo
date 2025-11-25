--
--  from src/line.c
--
--    void gr_line(int, int, int, int, long)  to   BMP; :line
--
--  from src/svgplot.c
--
--    ... some extensions for basic shapes    are  :line
--

local RAND = require 'rand'.RAND

function loop(instance, n, x, y, formatFunction)
	local r = RAND()
	for _=1,n do
		instance:line(
			r:rand() % x,
			r:rand() % y,
			r:rand() % x,
			r:rand() % y,
			formatFunction(r:randRaw() % (0xffffff + 1))
		)
	end
end

do
	local run = require("_helper").template_forBasicShapes(loop)
	run("results/line", 100, 640, 400)
end
