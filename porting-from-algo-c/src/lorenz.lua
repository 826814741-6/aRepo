--
--	from src/lorenz.c
--
--	a part of main		to	lorenzAttractor
--

local function lorenzAttractor(plotter, S, R, B, n, a1, a2, a3, a4)
	function step(x, y, z)
		return x + a1*(S*(y-x)), y + a1*(x*(R-z)-y), z + a1*(x*y-B*z)
	end

	local x, y, z = 1, 1, 1

	for _=1,100 do
		x, y, z = step(x, y, z)
		plotter:move(a2 * x + a3, a2 * z - a4)
	end

	for _=101,n do
		x, y, z = step(x, y, z)
		plotter:draw(a2 * x + a3, a2 * z - a4)
	end
end

local function extension(T)
	function T:lorenzAttractor(S, R, B, n, a1, a2, a3, a4)
		lorenzAttractor(T, S, R, B, n, a1, a2, a3, a4)
		return T
	end
	return T
end

return {
	lorenzAttractor = lorenzAttractor,
	extension = extension
}
