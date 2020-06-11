#
#	from src/sum.c
#
#	float sum1(int, float[])	to	sum1
#	float sum2(int, float[])	to	sum2
#

from sum import sum1, sum2

n = 10000
a = [ 1/n for _ in range(n) ]

assert(0.0001 == 1/n)

print("1.0 == {0} : {1}".format("sum(a)", 1.0 == sum(a)))
print("1.0 == {0} : {1}".format("sum1(a)", 1.0 == sum1(a)))
print("1.0 == {0} : {1}".format("sum2(a)", 1.0 == sum2(a)))
