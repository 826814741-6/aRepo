--
--	from src/ccurve.c
--
--	void c(int, double, double)	to	ccurve
--

local function ccurve(plotter, i, x, y)
	if i == 0 then
		plotter:drawRel(x, y)
	else
		ccurve(plotter, i - 1, (x + y) / 2, (y - x) / 2)
		ccurve(plotter, i - 1, (x - y) / 2, (y + x) / 2)
	end
end

return {
	ccurve = ccurve
}
