#
#	from src/dayweek.c
#
#	a part of main	to	dayweek, initArray
#

from dayweek import dayweek, initArray

a = initArray()

for i in range(21, 32):
    print("{0:4d}/{1:02d}/{2:02d} {3}".format(2019, 12, i, a[dayweek(2019,12,i)]))

for i in range(1, 12):
    print("{0:4d}/{1:02d}/{2:02d} {3}".format(2020, 1, i, a[dayweek(2020,1,i)]))
