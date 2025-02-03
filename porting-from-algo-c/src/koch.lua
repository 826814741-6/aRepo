--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local isNum = require '_helper'.isNum

local m_sin, m_cos, PI = math.sin, math.cos, math.pi

local function koch(plotter, d, a, dmax)
	dmax = isNum(dmax) and dmax or 3

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

return {
	koch = koch
}
