--
--	from src/gcd.c
--
--	int gcd(int, int) ; recursive	to	gcdR
--	int gcd(int, int) ; loop	to	gcdL
--	int ngcd(int, int[])		to	ngcdL
--	ngcdL				to	ngcdR
--

local isTbl = require '_helper'.isTbl

local function gcdR(x, y)
	if y == 0 then
		return x
	else
		return gcdR(y, x % y)
	end
end

local function gcdL(x0, y0)
	local x, y = x0, y0
	while y ~= 0 do
		x, y = y, x % y
	end
	return x
end

local function ngcdL(a)
	assert(isTbl(a), "ngcdL needs a table (of numbers).")
	local d = a[1]
	for i=2,#a do
		if d == 1 then break end
		d = gcdL(a[i], d)
	end
	return d
end

local function ngcdR(a)
	assert(isTbl(a), "ngcdR needs a table (of numbers).")
	function rec(i, d)
		if i > #a or d == 1 then
			return d
		else
			return rec(i+1, gcdR(a[i], d))
		end
	end
	return rec(1, a[1])
end

return {
	gcdR = gcdR,
	gcdL = gcdL,
	ngcdL = ngcdL,
	ngcdR = ngcdR
}
