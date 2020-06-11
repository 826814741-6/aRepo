--
--	from src/dayweek.c
--
--	a part of main	to	dayweek, initArray
--

local M = require 'dayweek'

local dayweek, initArray = M.dayweek, M.initArray

do
	local a = initArray()

	for i=21,31 do
		print(("%4d/%02d/%02d %s"):format(2019, 12, i, a[dayweek(2019,12,i)]))
	end

	for i=1,11 do
		print(("%4d/%02d/%02d %s"):format(2020, 1, i, a[dayweek(2020,1,i)]))
	end
end
