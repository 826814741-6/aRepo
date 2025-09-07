--
--  from src/crnd.c
--
--    void init_rnd(unsigned long)  to  crnd; :init
--    unsigned long irnd(void)      to  crnd; :irnd
--    double rnd(void)              to  crnd; :rnd
--

local crnd = require 'crnd'.crnd

function p(m, n, crnd)
	for _=1,n do
		for _=1,m do
			io.write(("%10.7f"):format(crnd:rnd()))
		end
		io.write("\n")
	end
end

do
	local c = crnd(12345)

	p(8, 20, c)

	assert(954228167081776094 == c:irnd())
	c:init(1)
	assert(1566083942 == c:irnd())
	c:init(12345)
	assert(19333306251646 == c:irnd())
end
