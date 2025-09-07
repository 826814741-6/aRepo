--
--  src/randperm.c
--
--    void shuffle(int, int [])   to  shuffle
--    void randperm(int, int [])  to  randPerm
--

local M0 = require 'crnd'
local M1 = require 'randperm'

local crnd = M0.crnd
local randPerm, shuffle = M1.randPerm, M1.shuffle

function checkUniqueness(a)
	local t = {}
	for i=0,#a do
		if t[a[i]] == true then
			error(("ERROR: %d:%q is duplicated."):format(i, a[i]))
		end
		t[a[i]] = true
	end
end

do
	local rand = crnd()
	local a = randPerm(100, rand)

	checkUniqueness(a)

	for j=0,9 do
		for i=0,9 do
			io.write(("%4d"):format(a[i+j*10]))
		end
		print()
	end

	print("--------")

	a = randPerm(26, rand, function (x) return string.char(x + 65) end)

	checkUniqueness(a)

	assert(table.concat(a, "", 0) == a[0]..table.concat(a)) -- (*) see below
	print(table.concat(a, "", 0))

	for _=1,9 do
		shuffle(a, rand)
		checkUniqueness(a)
		print(table.concat(a, "", 0))
	end
end

--
-- *) see: 6.6 - Table Manipulation (Lua 5.4 Reference Manual)
--
-- >> Remember that, whenever an operation needs the length of a table,
-- >> all caveats about the length operator apply (see §3.4.7). ...
--
-- >> table.concat (list [, sep [, i [, j]]])
-- >>
-- >> ... The default value for sep is the empty string, the default for i is 1,
-- >> and the default for j is #list. ...
--
