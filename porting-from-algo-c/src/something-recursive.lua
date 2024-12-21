--
--	from src/acker.c
--
--	int A(int, int)		to	ack
--
--	from src/eulerian.c
--
--	Eulerian	to	eulerianNumber
--
--	from src/mccarthy.c
--
--	int McCarthy(int)	to	mccarthy91
--
--	from src/stirling.c
--
--	int Stirling1(int, int)		to	stirling1
--	int Stirling2(int, int)		to	stirling2
--
--	from src/tarai.c
--
--	int tarai(int, int, int)	to	tarai
--	tarai				to	taraiC
--	tarai				to	tak(*)
--
--	*) https://en.wikipedia.org/wiki/Tak_(function)
--

local function ack(x, y)
	if x == 0 then return y + 1 end
	if y == 0 then return ack(x - 1, 1) end
	return ack(x - 1, ack(x, y - 1))
end

local function eulerianNumber(n, k)
	if k == 0 then return 1 end
	if k < 0 or k >= n then return 0 end
	return (k+1) * eulerianNumber(n-1, k) + (n-k) * eulerianNumber(n-1, k-1)
end

local function mccarthy91(x)
	if x > 100 then
		return x - 10
	else
		return mccarthy91(mccarthy91(x + 11))
	end
end

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

local function tarai(x, y, z)
	if x <= y then return y end
	return tarai(tarai(x-1, y, z), tarai(y-1, z, x), tarai(z-1, x, y))
end

local function taraiC(x, y, z)
	function rec(x, y, z)
		if x() <= y() then return y() end
		return rec(
			function () return rec(function() return x() - 1 end, y, z) end,
			function () return rec(function() return y() - 1 end, z, x) end,
			function () return rec(function() return z() - 1 end, x, y) end
		)
	end
	return rec(
		function () return x end,
		function () return y end,
		function () return z end
	)
end

local function tak(x, y, z)
	if x <= y then return z end
	return tak(tak(x-1, y, z), tak(y-1, z, x), tak(z-1, x, y))
end

return {
	ack = ack,
	eulerianNumber = eulerianNumber,
	mccarthy91 = mccarthy91,
	stirling1 = stirling1,
	stirling2 = stirling2,
	tarai = tarai,
	taraiC = taraiC,
	tak = tak
}
