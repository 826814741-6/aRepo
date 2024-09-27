--
--	from src/mccarthy.c
--
--	int McCarthy(int)	to	mccarthy91
--

local mccarthy91 = require 'mccarthy'.mccarthy91

local function _t_mccarthy91(l, r)
	for i=l,r do
		local t = mccarthy91(i)
		if t ~= 91 then
			print(("ERROR: %d %d"):format(i, t))
			os.exit()
		end
	end
	print(("mccarthy91 seems to be 91 in %d to %d"):format(l, r))
end

do
	_t_mccarthy91(-(1 << 10), 100)

	print("... and in 101 to 110 are:")

	for i=101,110 do
		io.write(("%4d:%d"):format(i, mccarthy91(i)))
	end
	print()
end
