--
--  from src/whrnd.c
--
--    void init_rnd(int, int, int)  to  whrnd; :init
--    double rnd(void)              to  whrnd; :rnd
--

local function whrnd(x, y, z)
	local T = { x = x, y = y, z = z }

	function T:init(x, y, z)
		T.x, T.y, T.z = x, y, z
	end

	function T:rnd()
		T.x = 171 * (T.x % 177) -  2 * (T.x // 177)
		T.y = 172 * (T.y % 176) - 35 * (T.y // 176)
		T.z = 170 * (T.z % 178) - 63 * (T.z // 178)
		if T.x < 0 then T.x = T.x + 30269 end
		if T.y < 0 then T.y = T.y + 30307 end
		if T.z < 0 then T.z = T.z + 30323 end
		local r = T.x / 30269 + T.y / 30307 + T.z / 30323
		while r >= 1 do r = r - 1 end
		return r
	end

	return T
end

return {
	whrnd = whrnd
}
