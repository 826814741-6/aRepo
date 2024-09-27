--
--	from src/totient.c
--
--	unsigned phi(unsigned)		to	phi
--

local function phi(x0)
	local x, t = x0, x0
	if x % 2 == 0 then
		t = t // 2
		repeat
			x = x // 2
		until x % 2 ~= 0
	end

	local d = 3
	while x // d >= d do
		if x % d == 0 then
			t = t // d * (d - 1)
			repeat
				x = x // d
			until x % d ~= 0
		end
		d = d + 2
	end

	if x > 1 then
		t = t // x * (x - 1)
	end

	return t
end

return {
	phi = phi
}
