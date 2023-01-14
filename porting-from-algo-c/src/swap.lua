--
--	from src/swap.c
--
--	void swap(int *, int *)		to	swap
--

local function swap(a, x, y)
	a[x], a[y] = a[y], a[x]
end

return {
	swap = swap
}
