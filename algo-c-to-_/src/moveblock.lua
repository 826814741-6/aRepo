--
--	from src/movebloc.c
--
--	void reverse(int, int)		to	reverse
--	void rotate(int, int, int)	to	rotate
--

local H = require '_helper'

local decrement = H.decrement
local increment = H.increment

local function reverse(a, i, j)
	while i < j do
		a[i], a[j] = a[j], a[i]
		i, j = increment(i), decrement(j)
	end
end

local function rotate(a, left, mid, right)
	reverse(a, left, mid)
	reverse(a, increment(mid), right)
	reverse(a, left, right)
end

return {
	reverse = reverse,
	rotate = rotate
}
