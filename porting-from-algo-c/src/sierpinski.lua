--
--  from src/gasket.c
--
--    triangle and a part of main  to  sierpinskiGasket
--

local function sierpinskiGasket(bmp, n, fgColor, bgColor)
	function triangle(i, j)
		bmp:wLine(i, j+1, i-1, j, fgColor)
		bmp:wLine(i-1, j, i+1, j, fgColor)
		bmp:wLine(i+1, j, i, j+1, fgColor)
	end

	bmp:clear(bgColor)
	bmp:setWindow(0, 2 * n, n, 0, true)

	local a, b = {}, {}
	for i=0,2*n do a[i] = false end
	a[n] = true

	for j=1,n-1 do
		for i=n-j,n+j do
			if a[i] == true then
				triangle(i, n - j)
			end
		end
		for i=n-j,n+j do
			b[i] = a[i - 1] ~= a[i + 1]
		end
		for i=n-j,n+j do
			a[i] = b[i]
		end
	end
end

return {
	sierpinskiGasket = sierpinskiGasket
}
