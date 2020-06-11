--
--	from src/gcd.c
--
--	int gcd(int, int) ; recursive	to	gcdR
--	int gcd(int, int) ; loop	to	gcdL
--	int ngcd(int, int[])		to	ngcdL
--	ngcdL				to	ngcdR
--

local function gcdR(x, y)
	if y == 0 then
		return x
	else
		return gcdR(y, x % y)
	end
end

local function gcdL(x, y)
	while y ~= 0 do
		x, y = y, x % y
	end
	return x
end

local function ngcdL(a)
	assert(type(a) == "table", "ngcdL needs a table (of numbers).")
	local d = a[1]
	for i=2,#a do
		if d == 1 then break end
		d = gcdL(a[i], d)
	end
	return d
end

local function ngcdR(a)
	assert(type(a) == "table", "ngcdR needs a table (of numbers).")
	function iter(i, d)
		if i > #a or d == 1 then
			return d
		else
			return iter(i+1, gcdR(a[i], d))
		end
	end
	return iter(1, a[1])
end

return {
	gcdR = gcdR,
	gcdL = gcdL,
	ngcdL = ngcdL,
	ngcdR = ngcdR
}
