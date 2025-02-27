--
--	from src/isbn.c
--
--	a part of main		to	isISBN10
--
--	from src/isbn13.c
--
--	a part of main		to	isISBN13
--
--	from src/luhn.c
--
--	a part of main		to	isLuhn
--

local isNum = require '_helper'.isNum
local isStr = require '_helper'.isStr

local function slicer(s)
	return function (i)
		local r = tonumber(s:sub(i,i))
		assert(
			isNum(r),
			("ERROR: can't convert '%s' to number."):format(s:sub(i,i))
		)
		return r
	end
end

local function isISBN10(s)
	assert(
		isStr(s) and #s == 10,
		"ERROR: ISBN-10 must be just 10 digits."
	)

	local t, f = {}, slicer(s)

	for i=1,9 do t[i] = f(i) end
	t[10] = (s:sub(10,10)=="X" or s:sub(10,10)=="x") and 10 or f(10)

	for i=2,10 do t[i] = t[i] + t[i-1] end
	for i=2,10 do t[i] = t[i] + t[i-1] end

	return t[10] % 11 == 0
end

local function isISBN13(s)
	assert(
		isStr(s) and #s == 13,
		"ERROR: ISBN-13 must be just 13 digits."
	)

	local t, w, f = 0, 1, slicer(s)

	for i=13,1,-1 do
		t, w = t + w * f(i), 4 - w
	end

	return t % 10 == 0
end

local function isLuhn(s)
	assert(isStr(s))

	local t, w, f = 0, 1, slicer(s)

	for i=1,#s do
		local d = w * f(i)
		t, w = d > 9 and t + d - 9 or t + d, 3 - w
	end

	return t % 10 == 0
end

return {
	isISBN10 = isISBN10,
	isISBN13 = isISBN13,
	isLuhn = isLuhn
}
