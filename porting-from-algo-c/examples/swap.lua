--
--	from src/swap.c
--
--	void swap(int *, int *)		to	swap
--

local M = require 'swap'

local swap = M.swap

do
	local a = { 1.23, 4.56, 7.89 }

	print(("%.2f %.2f %.2f\n\t%d <-> %d (%s)"):format(a[1], a[2], a[3], 1, 2, "swap"))
	swap(a, 1, 2)

	print(("%.2f %.2f %.2f\n\t%d <-> %d (%s)"):format(a[1], a[2], a[3], 1, 2, "swap"))
	swap(a, 1, 2)

	print(("%.2f %.2f %.2f\n\t%d <-> %d (%s)"):format(a[1], a[2], a[3], 2, 3, "swap"))
	swap(a, 2, 3)

	print(("%.2f %.2f %.2f\n\t%d <-> %d (%s)"):format(a[1], a[2], a[3], 3, 2, "swap"))
	swap(a, 3, 2)

	print(("%.2f %.2f %.2f"):format(a[1], a[2], a[3]))
end
