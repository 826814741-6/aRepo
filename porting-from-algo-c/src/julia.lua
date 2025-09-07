--
--  from src/julia.c
--
--    a part of main  to  julia
--

local m_sqrt = math.sqrt

local function predicate(x, y, n)
	return x * x + y * y < n
end

local function julia(bmp, X, Y, colorA, colorB, colorC, colorD)
	local C, JMID, YA = 4 / X, Y // 2, m_sqrt(3) / 2

	bmp:clear(colorD)

	for i=1,X do
		local x0 = C * i - 2
		for j=0,JMID do
			local x, y = x0, C * j
			for _=0,15 do
				local d = x * x + y * y
				if d < 1e-10 then break end
				d = d * d

				x, y = (1/3) * (2*x + (x*x-y*y)/d), (2/3) * y * (1 - x/d)

				if predicate(x - 1, y, 0.0025) then
					bmp:dot(i, JMID + j, colorA)
					bmp:dot(i, JMID - j, colorA)
					break
				end
				if predicate(x + 0.5, y + YA, 0.0025) then
					bmp:dot(i, JMID + j, colorB)
					bmp:dot(i, JMID - j, colorC)
					break
				end
				if predicate(x + 0.5, y - YA, 0.0025) then
					bmp:dot(i, JMID + j, colorC)
					bmp:dot(i, JMID - j, colorB)
					break
				end
			end
		end
	end
end

return {
	julia = julia
}
