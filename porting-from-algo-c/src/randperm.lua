--
--	src/randperm.c
--
--	void shuffle(int, int [])	to	shuffle
--	void randperm(int, int [])	to	randPerm
--

local H = require '_helper'

local m_floor = math.floor
local decrement = H.decrement
local increment = H.increment
local isFun = H.isFun

local function shuffle(a, rand) -- see below
	for i=#a,1,-1 do
		local j = m_floor(increment(i) * rand:rnd())
		a[i], a[j] = a[j], a[i]
	end
end

--
-- shuffle(a, ...) expects that 'a' is a table:
--
--   { [0]=..., ..., ..., ... }
--
-- cf. Some samples of the behavior '#'(length) operator and '[0(<=0)]'
--
-- assert(#{ [0]=1, 2, 3, 4 } == 3)      --  0:1, 1:2, 2:3, 3:4
-- assert(#{ [-1]=1, 2, 3, 4 } == 3)     -- -1:1, 1:2, 2:3, 3:4
-- assert(#{ [-1]=1, [0]=2, 3, 4 } == 2) -- -1:1, 0:2, 1:3, 2:4
--
-- ... and something like a pitfall
--
-- assert(#{ [2]=1, 2, 3, 4 } == 3)      -- 1:2, 2:3, 3:4
-- assert(#{ 1, 2, 3, [2]=4 } == 3)      -- 1:1, 2:2, 3:3
-- assert(#{ [5]=1, 2, 3, 4 } == 3)      -- 1:2, 2:3, 3:4, 5:1
--
-- (see 3.4.7 - The Length Operator (Lua 5.4 Reference Manual))
--

local function randPerm(n, rand, f)
	f = isFun(f) and f or increment

	local a = {}
	for i=0,decrement(n) do a[i] = f(i) end
	shuffle(a, rand)

	return a
end

return {
	shuffle = shuffle,
	randPerm = randPerm
}
