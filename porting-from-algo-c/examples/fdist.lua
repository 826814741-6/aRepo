--
--	from src/fdist.c
--
--	double q_f(int, int, double)		to	qF
--	double p_f(int, int, double)		to	pF
--

local pF = require 'distribution'.pF

do
	for _,df1 in ipairs({1, 2, 5, 20}) do
		print(("-------- pF(%d, df2, f)"):format(df1))
		print(
			("  F   %-16s %-16s %-16s %-16s")
				:format(
					"df2=1",
					"df2=2",
					"df2=5",
					"df2=20"
				)
		)

		for i=0,10 do
			print(
				("%4d %16.14f %16.14f %16.14f %16.14f")
					:format(
						i,
						pF(df1,1,i),
						pF(df1,2,i),
						pF(df1,5,i),
						pF(df1,20,i)
					)
			)
		end
	end
end
