--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local sin, cos, PI = math.sin, math.cos, math.pi

local function koch(plotter, d, a, dmax)
	dmax = dmax ~= nil and dmax or 3

	function iter()
		if d > dmax then
			d = d / 3
			iter()
			a = a + 1
			iter()
			a = a + 4
			iter()
			a = a + 1
			iter()
			d = d * 3
		else
			plotter:drawRel(d * cos((a % 6) * PI / 3), d * sin((a % 6) * PI / 3))
		end
	end

	iter()
end

return {
	koch = koch
}
