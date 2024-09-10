--
--	from src/lissaj.c
--
--	a part of main		to	lissajousCurve
--

local PI = math.pi

local sin = math.sin
local cos = math.cos

local function lissajousCurve(plotter, n, offset)
	function step(a, b)
		return n + offset + n * cos(a), n + offset + n * sin(b)
	end

	plotter:move(step(0, 0))
	for i=1,360 do
		plotter:draw(step(3 * (PI / 180) * i, 5 * (PI / 180) * i))
	end
end

local function extension(T)
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
