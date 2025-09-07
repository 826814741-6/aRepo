--
--  from src/horner.c
--
--    double horner(int, double a[], double)  to  horner
--

local horner = require 'horner'.horner

function fmt(a)
	assert(#a > 0, "ERROR: 'a' must be a table that contains at least one element.")

	local r = {}
	for i=#a,3,-1 do
		table.insert(r, ("%d * x^%d"):format(a[i], i-1))
	end
	if a[2] ~= nil then
		table.insert(r, ("%d * x"):format(a[2]))
	end
	table.insert(r, a[1])
	return "f(x) = " .. table.concat(r, " + ")
end

do
	local a = {1, 2, 3, 4, 5}
	print(fmt(a))
	print(("f(%d) = %d"):format(2, horner(a,2)))
	print(("f(%d) = %d"):format(11, horner(a,11)))
	print(("f(%d) = %d"):format(121, horner(a,121)))
end
