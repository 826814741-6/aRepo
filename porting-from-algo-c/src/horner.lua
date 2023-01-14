--
--	from src/horner.c
--
--	double horner(int, double a[], double)		to	horner
--

--
--	a = {number, number, number, number, number, ...}
--
--	[1] + [2] * x + [3] * x^2 + [4] * x^3 + [5] * x^4 + ...
--
--	... + [5] * x^4 + [4] * x^3 + [3] * x^2 + [2] * x^1 + [1]
--

local function horner(a, x)
	assert(#a > 0, "ERROR: 'a' must be a table that contains at least one element.")

	local p = a[#a]
	for i=#a-1,1,-1 do
		p = p * x + a[i]
	end
	return p
end

return {
	horner = horner
}
