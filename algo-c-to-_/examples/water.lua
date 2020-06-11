--
--	from src/water.c
--
--	a part of main		to	isMeasurable
--

local M = require 'water'

local isMeasurable = M.isMeasurable

local read, write = io.read, io.write

do
	write("Please specify the capacity of the A container > ")
	local a = read("*n")
	write("Please specify the capacity of the B container > ")
	local b = read("*n")
	write("How much water do you need? > ")
	local v = read("*n")

	if isMeasurable(a, b, v) then
		local x, y = 0, 0
		repeat
			if x == 0 then
				x = a
				write(("(A:%d, B:%d)... A is FULL (tank -> A)\n"):format(x, y))
			elseif y == b then
				y = 0
				write(("(A:%d, B:%d)... B is EMPTY (B -> tank)\n"):format(x, y))
			elseif x < b - y then
				x, y = 0, y + x
				write(("(A:%d, B:%d)... A is EMPTY (A -> B)\n"):format(x, y))
			else
				x, y = x - (b - y), b
				write(("(A:%d, B:%d)... B is FULL (A -> B)\n"):format(x, y))
			end
		until x == v or y == v
		write(("Thank you for waiting. Here you are...(%s)\n"):format(x==v and "A" or "B"))
	else
		write("I'm afraid I can't measure it with A,B.\n")
	end
end
