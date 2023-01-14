--
--	from src/crnd.c
--
--	void init_rnd(unsigned long)		to	crnd; :init
--	unsigned long irnd(void)		to	crnd; :irnd
--	double rnd(void)			to	crnd; :rnd
--

local M = require 'crnd'

local crnd = M.crnd

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
end
