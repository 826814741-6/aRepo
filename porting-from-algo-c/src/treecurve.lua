--
--	from src/treecurv.c
--
--	void tree(int, double, double)		to	treeCurve
--

local m_sin, m_cos = math.sin, math.cos

local function treeCurve(plotter, n, length, angle, factor, turn)
	local x, y = length * m_sin(angle), length * m_cos(angle)
	plotter:drawRel(x, y)
	if n > 0 then
		treeCurve(plotter, n-1, length * factor, angle + turn, factor, turn)
		treeCurve(plotter, n-1, length * factor, angle - turn, factor, turn)
	end
	plotter:moveRel(-x, -y)
end

local function extension(T)
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
