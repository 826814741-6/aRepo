--
--  from src/dragon.c
--
--    void dragon(int, double, double, int)  to  dragonCurveR
--
--  from src/dragon2.c
--
--    a part of main                         to  dragonCurve
--

local function rec(plotter, i, dx, dy, sign)
	if i == 0 then
		plotter:drawRel(dx, dy)
	else
		rec(plotter, i-1, (dx - sign*dy) / 2, (dy + sign*dx) / 2, 1)
		rec(plotter, i-1, (dx + sign*dy) / 2, (dy - sign*dx) / 2, -1)
	end
end

local function dragonCurveR(plotter, order, dx, dy, sign, x0, y0)
	plotter:move(x0, y0)
	rec(plotter, order, dx, dy, sign)
end

local function dragonCurve(plotter, order, x0, y0)
	plotter:move(x0, y0)

	local dx, dy = 0, 2
	plotter:drawRel(3 * dx, 3 * dy)

	local fold, p = {}, 0
	for _=1,order do
		local q = p * 2
		fold[p] = true
		for i=p,q do
			local dx1, dy1

			if fold[q-i] == true then
				fold[i], dx1, dy1 = false, dy, -dx
			else
				fold[i], dx1, dy1 = true, -dy, dx
			end

			plotter
				:drawRel(dx + dx1, dy + dy1)
				:drawRel(3 * dx1, 3 * dy1)

			dx, dy = dx1, dy1
		end
		p = q + 1
	end
end

return {
	dragonCurveR = dragonCurveR,
	dragonCurve = dragonCurve
}
