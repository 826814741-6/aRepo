--
--	from src/water.c
--
--	a part of main		to	isMeasurable
--

local isMeasurable = require 'water'.isMeasurable

local i_read, i_write = io.read, io.write

do
	i_write("Please specify the capacity of the A container. > ")
	local a = i_read("*n")
	i_write("Please specify the capacity of the B container. > ")
	local b = i_read("*n")
	i_write("How much water do you need? > ")
	local v = i_read("*n")

	if isMeasurable(a, b, v) then
		local x, y = 0, 0
		repeat
			if x == 0 then
				x = a
				i_write(("(A:%d, B:%d)... A is FULL (tank -> A)\n"):format(x, y))
			elseif y == b then
				y = 0
				i_write(("(A:%d, B:%d)... B is EMPTY (B -> tank)\n"):format(x, y))
			elseif x < b - y then
				x, y = 0, y + x
				i_write(("(A:%d, B:%d)... A is EMPTY (A -> B)\n"):format(x, y))
			else
				x, y = x - (b - y), b
				i_write(("(A:%d, B:%d)... B is FULL (A -> B)\n"):format(x, y))
			end
		until x == v or y == v
		i_write(("Thank you for waiting. Here you are...(%s).\n"):format(x==v and "A" or "B"))
	else
		i_write("I'm afraid I can't measure it with A,B.\n")
	end
end
