--
--	from src/tarai.c
--
--	int tarai(int, int, int)	to	tarai
--	tarai				to	tak(*)
--
--	*) https://en.wikipedia.org/wiki/Tak_(function)
--

local function tarai(x, y, z)
	if x <= y then return y end
	return tarai(tarai(x-1,y,z), tarai(y-1,z,x), tarai(z-1,x,y))
end

local function tak(x, y, z)
	if x <= y then return z end
	return tak(tak(x-1,y,z), tak(y-1,z,x), tak(z-1,x,y))
end

return {
	tarai = tarai,
	tak = tak
}
