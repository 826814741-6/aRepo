--
--	from src/change.c
--
--	int change(int, int)		to	changeR
--	int change1(int, int)		to	changeL
--

local function changeR(n, k)
	if n < 0 then return 0 end

	local r = 1 + n // 5 + changeR(n - 10, 10)
	if k >= 50 then r = r + changeR(n - 50, 50) end
	if k >= 100 then r = r + changeR(n - 100, 100) end

	return r
end

local function changeL(n)
	local r = 0
	for i=n//100,0,-1 do
		local t = n - 100 * i
		for j=t//50,0,-1 do
			local u = t - 50 * j
			r = r + (1 + u//5 - u//10) * (1 + u//10)
		end
	end
	return r
end

return {
	changeR = changeR,
	changeL = changeL
}
