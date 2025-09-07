--
--  from src/dayweek.c
--
--    a part of main  to  dayweek, initArray
--

local function dayweek(y, m, d)
	if m < 3 then y, m = y-1, m+12 end
	return (y + y//4 - y//100 + y//400 + (13*m+8)//5 + d) %7
end

local function initArray()
	return {
		[0]="Sunday",
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday"
	}
end

return {
	dayweek = dayweek,
	initArray = initArray
}
