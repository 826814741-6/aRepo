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

local M = require 'rand'

local RAND, crnd = M.RAND, M.crnd
local i_write = io.write

function p(col, row, fmt, v)
	for _=1,row do
		for _=1,col do
			io.write(fmt(v))
		end
		io.write("\n")
	end
end

do
	function fmtR(v) return ("%8d"):format(v:rand()) end
	function fmtC(v) return ("%10.7f"):format(v:rnd()) end

	print("-------- RAND")
	local r = RAND()
	p(8, 20, fmtR, r)

	assert(9899 == r:rand())
	r:srand(1)
	assert(16838 == r:rand())

	print("-------- crnd")
	local c = crnd(12345)
	p(8, 20, fmtC, c)

	assert(954228167081776094 == c:irnd())
	c:init(1)
	assert(1566083942 == c:irnd())
	c:init(12345)
	assert(19333306251646 == c:irnd())
end
