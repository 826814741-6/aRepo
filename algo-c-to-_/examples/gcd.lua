--
--	from src/gcd.c
--
--	int gcd(int, int) ; recursive	to	gcdR
--	int gcd(int, int) ; loop	to	gcdL
--	int ngcd(int, int[])		to	ngcdL
--	ngcdL				to	ngcdR
--

local M = require 'gcd'

local gcdL, gcdR, ngcdL, ngcdR = M.gcdL, M.gcdR, M.ngcdL, M.ngcdR

function _t_gcd(a)
	for _,v in ipairs(a) do
		assert(gcdL(v[1], v[2]) == v[3])
		assert(gcdR(v[1], v[2]) == v[3])
		assert(gcdL(v[1], v[2]) == gcdR(v[1], v[2]))
		if v[1] ~= v[2] then
			assert(gcdL(v[2], v[1]) == v[3])
			assert(gcdR(v[2], v[1]) == v[3])
		end
		assert(gcdL(gcdL(gcdL(v[1], v[2]), v[1]), v[2]) == v[3])
		assert(gcdR(gcdR(gcdR(v[1], v[2]), v[1]), v[2]) == v[3])
		assert(gcdL(gcdR(gcdL(v[1], v[2]), v[2]), v[1]) == v[3])
		assert(gcdR(gcdL(gcdR(v[1], v[2]), v[2]), v[1]) == v[3])
	end
	print(("gcdL and gcdR seem to be fine (in %d samples)."):format(#a))
end

function _t_ngcd(a)
	for _,v in ipairs(a) do
		assert(ngcdL(v[1]) == v[2])
		assert(ngcdR(v[1]) == v[2])
		assert(ngcdL(v[1]) == ngcdR(v[1]))
	end
	print(("ngcdL and ngcdR seem to be fine (in %d samples)."):format(#a))
end

do
	_t_gcd({
		{11, 121, 11},
		{22, 22, 22},
		{2, 3, 1},
		{2147483647, 2147483647*6700417, 2147483647},
		{67280421310721, 2305843009213693951, 1},
		{2305843009213693951, 2305843009213693951, 2305843009213693951}
	})

	_t_ngcd({
		{ {}, nil }, -- see below
		{ {1}, 1 },
		{ {10}, 10 },
		{ {2, 3}, 1},
		{ {22, 22, 22, 22, 22}, 22 },
		{ {11, 22, 33, 44, 55, 66, 77, 88, 99, 110}, 11 },
		{ {2147483647, 2147483647*6700417}, 2147483647 },
		{ {2147483647, 2147483647*6700417, 6700417}, 1 },
		{ {6700417, 2147483647, 2305843009213693951}, 1 }
	})
end

--
--	Some samples of nil and table (using as an array-like object)
--
--	> #{}, #{nil}, #{{}}, #{nil,{}}, #{{},nil}
--	0	0	1	2	1
--
--	> #{10,20,30}, #{10,20,30,nil}, #{[0]=0,10,20,30}
--	3	3	3
--
--	> #{nil,20,nil,nil,50}, #{nil,20,nil,nil,nil}, #{nil,nil,nil,nil,50}
--	5	2	5
--
--	> t={}
--	> t[1]=10
--	> #t
--	1
--	> t[3]=30
--	> #t
--	1
--	> t[2]=20
--	> #t
--	3
--	> t[2]=nil
--	> #t
--	1
--
