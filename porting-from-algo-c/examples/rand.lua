--
--	from src/rand.c
--
--	int rand(void)		to	rand
--	void srand(unsigned)	to	srand
--	rand, srand		to	RAND
--

local M = require 'rand'

local rand, RAND = M.rand, M.RAND
local write = io.write

print("-------- rand()")
for i=1,20 do
	for j=1,8 do
		write(("%8d"):format(rand()))
	end
	print()
end

print("-------- r:rand()")
local r = RAND()
for i=1,20 do
	for j=1,8 do
		write(("%8d"):format(r:rand()))
	end
	print()
end

assert(9899 == r:rand())
r:srand(1)
assert(16838 == r:rand())
