#
#	from src/whrnd.c
#
#	void init_rnd(int, int, int)		to	whrnd; .init
#	double rnd(void)			to	whrnd; .__call__
#

from whrnd import whrnd

def p(m, n, wh):
    for _ in range(n):
        print("".join("{0:10.7f}".format(wh()) for _ in range(m)))

print("-------- whrnd: 12345, 23451, 13579")
wh = whrnd(12345, 23451, 13579)
p(8, 20, wh)

print("-------- whrnd: 1, 2, 3")
wh.init(1, 2, 3)
p(8, 20, wh)

print("-------- whrnd: 12345, 23451, 13579")
wh.init(12345, 23451, 13579)
p(8, 20, wh)
