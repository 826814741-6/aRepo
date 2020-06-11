--
--	from src/sum.c
--
--	float sum1(int, float[])	to	sum1
--	float sum2(int, float[])	to	sum2
--

local function sum1(a)
	local r = 0
	for _,v in ipairs(a) do
		r = r + v
	end
	return r
end

local function sum2(a)
	local r, rest = 0, 0
	for _,v in ipairs(a) do
		rest = rest + v
		local t = r
		r = r + rest
		t = t - r
		rest = rest + t
	end
	return r
end

return {
	sum1 = sum1,
	sum2 = sum2
}
