--
--	from src/stirling.c
--
--	int Stirling1(int, int)		to	stirling1
--	int Stirling2(int, int)		to	stirling2
--

local function stirling1(n, k)
	if k < 1 or k > n then return 0 end
	if k == n then return 1 end
	return (n-1) * stirling1(n-1, k) + stirling1(n-1, k-1)
end

local function stirling2(n, k)
	if k < 1 or k > n then return 0 end
	if k == 1 or k == n then return 1 end
	return k * stirling2(n-1, k) + stirling2(n-1, k-1)
end

return {
	stirling1 = stirling1,
	stirling2 = stirling2
}
