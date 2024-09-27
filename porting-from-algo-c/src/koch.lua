--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local m_sin, m_cos, PI = math.sin, math.cos, math.pi

local function koch(plotter, d, a, dmax)
	dmax = dmax ~= nil and dmax or 3

	function rec()
		if d > dmax then
			d = d / 3
			rec()
			a = a + 1
			rec()
			a = a + 4
			rec()
			a = a + 1
			rec()
			d = d * 3
		else
			plotter:drawRel(
				d * m_cos((a % 6) * PI / 3),
				d * m_sin((a % 6) * PI / 3)
			)
		end
	end

	rec()
end

local function extension(T)
	function T:koch(d, a, dmax)
		koch(T, d, a, dmax)
		return T
	end
	return T
end

return {
	koch = koch,
	extension = extension
}
