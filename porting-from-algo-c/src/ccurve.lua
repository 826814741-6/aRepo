--
--	from src/ccurve.c
--
--	void c(int, double, double)	to	cCurve
--

local function cCurve(plotter, i, x, y)
	if i == 0 then
		plotter:drawRel(x, y)
	else
		cCurve(plotter, i - 1, (x + y) / 2, (y - x) / 2)
		cCurve(plotter, i - 1, (x - y) / 2, (y + x) / 2)
	end
end

local mustBePlotter = require 'svgplot'.mustBePlotter

local function extension(T)
	mustBePlotter(T)
	function T:cCurve(i, x, y)
		cCurve(T, i, x, y)
		return T
	end
	return T
end

return {
	cCurve = cCurve,
	extension = extension
}
