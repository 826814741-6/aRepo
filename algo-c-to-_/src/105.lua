--
--	from src/105.c
--
--	a part of main		to	guess105
--

local function guess105(a, b, c)
	return (70 * a + 21 * b + 15 * c) % 105
end

return {
	guess105 = guess105
}
