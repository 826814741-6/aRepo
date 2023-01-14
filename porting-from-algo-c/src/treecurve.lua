--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treecurve
--

local sin, cos = math.sin, math.cos

local function treecurve(plotter, n, length, angle, factor, turn)
	local x, y = length * sin(angle), length * cos(angle)
	plotter:drawRel(x, y)
	if n > 0 then
		treecurve(plotter, n-1, length * factor, angle + turn, factor, turn)
		treecurve(plotter, n-1, length * factor, angle - turn, factor, turn)
	end
	plotter:moveRel(-x, -y)
end

return {
	treecurve = treecurve
}
