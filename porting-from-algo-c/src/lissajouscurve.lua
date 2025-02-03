--
--	from src/lissaj.c
--
--	a part of main		to	lissajousCurve
--

local PI = math.pi

local m_sin = math.sin
local m_cos = math.cos

local function lissajousCurve(plotter, n, offset)
	function step(a, b)
		return n + offset + n * m_cos(a), n + offset + n * m_sin(b)
	end

	plotter:move(step(0, 0))
	for i=1,360 do
		plotter:draw(step(3 * (PI / 180) * i, 5 * (PI / 180) * i))
	end
end

return {
	lissajousCurve = lissajousCurve
}
