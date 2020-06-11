--
--	from src/jos1.c
--
--	a part of main		to	josephusProblem1
--
--	from src/jos2.c
--
--	a part of main		to	josephusProblem2
--

local M = require 'josephus'

local josephusProblem1, josephusProblem2 = M.josephusProblem1, M.josephusProblem2

do
	assert(josephusProblem1(41, 3) == 31)
	assert(josephusProblem2(41, 3) == 31)

	io.write("How many people are there? (N)> ")
	local n = io.read("*n")
	io.write("Which one do you choose (per step)? (N (th))> ")
	local p = io.read("*n")

	assert(josephusProblem1(n, p) == josephusProblem2(n, p))
	
	io.write(("The %dth person survives."):format(josephusProblem1(n, p)), "\n")
end
