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

local mustBePlotter = require 'svgplot'.mustBePlotter

local function extension(T)
	mustBePlotter(T)
	function T:lissajousCurve(n, offset)
		lissajousCurve(T, n, offset)
		return T
	end
	return T
end

return {
	lissajousCurve = lissajousCurve,
	extension = extension
}
