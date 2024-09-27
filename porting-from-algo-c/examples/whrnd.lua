--
--	from src/whrnd.c
--
--	void init_rnd(int, int, int)		to	whrnd; :init
--	double rnd(void)			to	whrnd; :rnd
--

local whrnd = require 'whrnd'.whrnd

function p(m, n, wh)
	for _=1,n do
		for _=1,m do
			io.write(("%10.7f"):format(wh:rnd()))
		end
		io.write("\n")
	end
end

do
	print("-------- whrnd: 12345, 23451, 13579")
	local wh = whrnd(12345, 23451, 13579)
	p(8, 20, wh)

	print("-------- whrnd: 1, 2, 3")
	wh:init(1, 2, 3)
	p(8, 20, wh)

	print("-------- whrnd: 12345, 23451, 13579")
	wh:init(12345, 23451, 13579)
	p(8, 20, wh)
end
