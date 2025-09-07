--
--  from src/bifur.c
--
--    a part of main  to  bifur
--

local function bifur(bmp, fgColor, bgColor, x, kmin, kmax, pmin, pmax)
	bmp:clear(bgColor)

	bmp:setWindow(kmin, kmax, pmax, pmin)

	local dk = (kmax - kmin) / (x - 1)
	for k=kmin,kmax,dk do
		local p = 0.3
		for i=1,50 do
			p = p + (k * p * (1 - p))
		end
		for i=51,100 do
			if p >= pmin and p <= pmax then
				bmp:wDot(k, p, fgColor)
			end
			p = p + (k * p * (1 - p))
		end
	end
end

return {
	bifur = bifur
}
