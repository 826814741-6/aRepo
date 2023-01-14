--
--	from src/mccarthy.c
--
--	int McCarthy(int)	to	mccarthy91
--

local function mccarthy91(x)
	if x > 100 then
		return x - 10
	else
		return mccarthy91(mccarthy91(x + 11))
	end
end

return {
	mccarthy91 = mccarthy91
}
