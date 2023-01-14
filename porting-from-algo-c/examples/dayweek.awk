#
#	from src/dayweek.c
#
#	a part of main	to	dayweek, initArray
#

BEGIN {
	initArray(A)

	for (i=21;i<=31;i++)
		printf "%4d/%02d/%02d %s\n", 2019, 12, i, A[dayweek(2019,12,i)]

	for (i=1;i<=11;i++)
		printf "%4d/%02d/%02d %s\n", 2020, 1, i, A[dayweek(2020,1,i)]
}
