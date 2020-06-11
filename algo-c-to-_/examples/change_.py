#
#	from src/change.c
#
#	int change(int, int)		to	changeR
#	int change1(int, int)		to	changeL
#

from change import changeR, changeL

for i in range(0, 501, 5):
    a, b = changeR(i, i), changeL(i)

    assert a == b, "changeR(i,i) != changeL(i) (i:{0}, changeR:{1}, changeL:{2})".format(i, a, b)

    print("{0:4d} {1:8d}".format(i, a))
