--
--	from src/eulerian.c
--
--	Eulerian	to	eulerianNumber
--

local function eulerianNumber(n, k)
	if k == 0 then return 1 end
	if k < 0 or k >= n then return 0 end
	return (k+1) * eulerianNumber(n-1,k) + (n-k) * eulerianNumber(n-1,k-1)
end

return {
	eulerianNumber = eulerianNumber
}
