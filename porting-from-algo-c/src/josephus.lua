--
--	from src/jos1.c
--
--	a part of main		to	josephusProblem1
--
--	from src/jos2.c
--
--	a part of main		to	josephusProblem2
--

local function josephusProblem1(n, p)
	local k = 1
	for j=2,n do
		k = (k + p) % j
		if k == 0 then k = j end
	end
	return k
end

local function josephusProblem2(n, p)
	local k = p - 1
	while k < (p - 1) * n do
		k = (p * k) // (p - 1) + 1
	end
	return p * n - k
end

return {
	josephusProblem1 = josephusProblem1,
	josephusProblem2 = josephusProblem2
}
