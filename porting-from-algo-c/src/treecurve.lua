--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treeCurve
--

local sin, cos = math.sin, math.cos

local function treeCurve(plotter, n, length, angle, factor, turn)
	local x, y = length * sin(angle), length * cos(angle)
	plotter:drawRel(x, y)
	if n > 0 then
		treeCurve(plotter, n-1, length * factor, angle + turn, factor, turn)
		treeCurve(plotter, n-1, length * factor, angle - turn, factor, turn)
	end
	plotter:moveRel(-x, -y)
end

local mustBePlotter = require 'svgplot'.mustBePlotter

local function extension(T)
	mustBePlotter(T)
	function T:treeCurve(n, length, angle, factor, turn)
		treeCurve(T, n, length, angle, factor, turn)
		return T
	end
	return T
end

return {
	treeCurve = treeCurve,
	extension = extension
}
