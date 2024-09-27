--
--	from src/105.c
--
--	a part of main		to	guess105
--

local guess105 = require '105'.guess105

do
	io.write("Please pick a number 1 through 100.\n")
	io.write("...and the remainder of it divided by 3 is > ")
	local a = io.read("*n")
	io.write("...and the remainder of it divided by 5 is > ")
	local b = io.read("*n")
	io.write("...and the remainder of it divided by 7 is > ")
	local c = io.read("*n")
	io.write("Thank you for replying. I understand.\n")
	io.write(("The number you chose is %d, isn't it?\n"):format(guess105(a, b, c)))
end
