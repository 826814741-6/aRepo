--
--  from src/rand.c
--
--    int rand(void)        to  rand
--    void srand(unsigned)  to  srand
--    rand, srand           to  RAND; :rand, :srand
--                                    :randRaw
--

local isNum = require '_helper'.isNum

local function mustBeSeed(v)
	assert(
		isNum(v) and math.type(v) == "integer",
		[['seed' must be an integer(*).
(ref: https://www.lua.org/manual/5.4/manual.html#pdf-math.type)]]
	)
	return v
end

--

local next = 1

local function rand()
	next = next * 1103515245 + 12345
	return (next // 65536) % 32768
end

local function srand(seed)
	next = mustBeSeed(seed)
end

local function RAND(seed)
	local T = { next = seed ~= nil and mustBeSeed(seed) or 1 }

	function T:rand()
		T.next = T.next * 1103515245 + 12345
		return (T.next // 65536) % 32768
	end

	function T:srand(seed)
		T.next = mustBeSeed(seed)
	end

	function T:randRaw()
		T:rand()
		return T.next
	end

	return T
end

return {
	RAND_MAX = 32767,
	rand = rand,
	srand = srand,
	RAND = RAND
}
