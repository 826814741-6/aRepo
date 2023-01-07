--
--	from src/zeta.c
--
--	double zeta(double)	to	riemannZeta
--

local H = require '_helper'

local readOnlyTable = H.readOnlyTable

local coef = readOnlyTable({
	[0] = 8.333333333333333333333333333e-2,
	-1.388888888888888888888888889e-3,
	3.306878306878306878306878307e-5,
	-8.267195767195767195767195767e-7,
	2.087675698786809897921009032e-8,
	-5.284190138687493184847682202e-10,
	1.338253653068467883282698098e-11,
	-3.389680296322582866830195391e-13,
	8.586062056277844564135905450e-15,
	-2.174868698558061873041516424e-16,
	5.509002828360229515202652609e-18,
	-1.395446468581252334070768626e-19,
	3.534707039629467471693229977e-21,
	-8.953517427037546850402611251e-23,
	2.267952452337683060310950058e-24,
	-5.744790668872202445263829503e-26,
	1.455172475614864901866244572e-27,
	-3.685994940665310178130050728e-29,
	9.336734257095044668660153106e-31,
	-2.365022415700629886484029550e-32
})

local function riemannZeta(n)
	n = n ~= nil and n or 8
	return function (x)
		local r = 1
		for i=2,n-1 do
			local prev = r
			r = r + i ^ (-x)
			if r == prev then return r end
		end

		local powNX = n ^ x
		local w = x / (n * powNX)
		r = r + (0.5 / powNX + n / ((x - 1) * powNX) + coef[0] * w)

		for i=1,19 do
			w = w * ((x + 2 * i - 1) * (x + 2 * i) / (n * n))
			local prev = r
			r = r + coef[i] * w
			if r == prev then return r end
		end

		return r
	end
end

return {
	riemannZeta = riemannZeta
}
