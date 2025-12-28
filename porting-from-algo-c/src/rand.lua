--
--  from src/rand.c
--
--    int rand(void)                to  RAND; :rand, :randRaw
--    void srand(unsigned)          to  RAND; :srand
--
--  from src/crnd.c
--
--    void init_rnd(unsigned long)  to  crnd; :init
--    unsigned long irnd(void)      to  crnd; :irnd
--    double rnd(void)              to  crnd; :rnd
--

local isNum = require '_helper'.isNum

local function mustBeSeed(seed)
	assert(
		isNum(seed) and math.type(seed) == "integer",
		"'seed' must be an integer."

-- >> The type number represents both integer numbers and real (floating-point)
-- >> numbers, using two subtypes: integer and float. ...
-- >> -- https://www.lua.org/manual/5.5/manual.html#2.1
--
-- >> math.type(x)
-- >> Returns "integer" if x is an integer, "float" if it is a float, or fail
-- >> if x is not a number.
-- >> -- https://www.lua.org/manual/5.5/manual.html#pdf-math.type

	)
	return seed
end

--

local function R_rand(self)
	self.next = self.next * 1103515245 + 12345
	return (self.next // 65536) % 32768
end

local function R_srand(self, seed)
	self.next = mustBeSeed(seed)
end

local function R_randRaw(self)
	self:rand()
	return self.next
end

local function RAND(seed)
	local T = {
		RAND_MAX = 32767,
		next = seed ~= nil and mustBeSeed(seed) or 1
	}

	T.rand, T.srand, T.randRaw = R_rand, R_srand, R_randRaw

	return T
end

--

local N = 18446744073709551616 -- ULONG_MAX (limits.h) + 1

--
-- >> In case of overflows in integer arithmetic, all operations wrap around.
-- >> -- https://www.lua.org/manual/5.5/manual.html#3.4.1
--
-- > math.mininteger == math.maxinteger + 1
-- true
-- > math.mininteger - 1 == math.maxinteger
-- true
-- > math.ult(math.maxinteger, math.maxinteger + 1) == true
-- true
--
-- > math.maxinteger == 9223372036854775807
-- true
-- > math.mininteger == -9223372036854775808
-- true
-- > ("%u %u %u"):format(math.maxinteger, math.mininteger, -1)
-- 9223372036854775807 9223372036854775808 18446744073709551615
--
-- > math.type(N) == 'float'
-- true
-- > ("%f, %q"):format(N, N)
-- 18446744073709551616.000000, 0x1p+64
--
-- >> ... Standard Lua uses 64-bit integers and double-precision (64-bit)
-- >> floats, but you can also compile Lua so that it uses 32-bit integers
-- >> and/or single-precision (32-bit) floats. ...
-- >> -- https://www.lua.org/manual/5.5/manual.html#2.1
--

local function C_init(self, x)
	self.n = mustBeSeed(x)
end

local function C_irnd(self)
	self.n = self.n * 1566083941 + 1
	return self.n
end

local function C_rnd(self)
	local r = (1 / N) * self:irnd()
	return r < 0 and 1 + r or r
end

local function crnd(x)
	local T = { n = x ~= nil and mustBeSeed(x) or 1 }

	T.init, T.irnd, T.rnd = C_init, C_irnd, C_rnd

	return T
end

return {
	RAND = RAND,
	crnd = crnd
}
