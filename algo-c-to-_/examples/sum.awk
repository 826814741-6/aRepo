#
#	from src/sum.c
#
#	float sum1(int, float[])	to	sum1
#	float sum2(int, float[])	to	sum2
#

#
#	_p(b) from src/_helper.awk
#

BEGIN {
	n = 10000
	for (i = 1; i <= n; i++) a[i] = 1/n

	printf "1.0 == %s : %s\n", "sum1(a, n)", _p(1 == sum1(a, n))
	printf "1.0 == %s : %s\n", "sum2(a, n)", _p(1 == sum2(a, n))
}
