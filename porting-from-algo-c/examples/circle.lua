--
--  from src/circle.c
--
--    void gr_circle(int, int, int, long)   to   BMP; :circle
--
--  from src/svgplot.c
--
--    ... some extensions for basic shapes  are  :circle
--

local RAND = require 'rand'.RAND

function loop(instance, n, x, y, formatFunction)
	local r = RAND()
	for _=1,n do
		instance:circle(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			formatFunction(r:randRaw() % (0xffffff + 1))
		)
	end
end

do
	local run = require("_helper").template_forBasicShapes(loop)
	run("results/circle", 100, 640, 400)
end
