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

return {
	cCurve = cCurve
}
