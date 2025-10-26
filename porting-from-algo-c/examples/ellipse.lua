--
--  from src/ellipse.c
--
--    void gr_ellipse(int, int, int, int, long)  to   BMP; :ellipse
--
--  from src/svgplot.c
--
--    ... some extensions for basic shapes       are  :circle, :ellipse, :line, :rect
--

local RAND = require 'rand'.RAND

function loop(instance, n, x, y, formatFunction)
	local r = RAND()
	for _=1,n do
		instance:ellipse(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			r:rand() % 100,
			formatFunction(r:randRaw() % (0xffffff + 1))
		)
	end
end

do
	local run = require("_helper").template_forBasicShapes(loop)
	run("results/ellipse", 100, 640, 400)
end
