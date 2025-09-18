--
--  from src/dragon.c
--
--    void dragon(int, double, double, int)  to  dragonCurve
--

--local function rec(plotter, i, dx, dy, sign)
--	if i == 0 then
--		plotter:drawRel(dx, dy)
--	else
--		rec(plotter, i-1, (dx - sign*dy) / 2, (dy + sign*dx) / 2, 1)
--		rec(plotter, i-1, (dx + sign*dy) / 2, (dy - sign*dx) / 2, -1)
--	end
--end

local function dragonCurve(plotter, order, dx, dy, sign, x0, y0)
	function rec(i, dx, dy, sign)
		if i == 0 then
			plotter:drawRel(dx, dy)
		else
			rec(i-1, (dx - sign*dy) / 2, (dy + sign*dx) / 2, 1)
			rec(i-1, (dx + sign*dy) / 2, (dy - sign*dx) / 2, -1)
		end
	end

	plotter:move(x0, y0)
	rec(order, dx, dy, sign)
end

return {
	dragonCurve = dragonCurve
}
