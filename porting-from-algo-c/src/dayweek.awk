#
#  from src/dayweek.c
#
#    a part of main  to  dayweek, initArray
#

function dayweek(y, m, d) {
	if (m < 3) { y--; m += 12 }
	return (y + int(y/4) - int(y/100) + int(y/400) + int((13*m+8)/5) + d) % 7
}

function initArray(a) {
	split("Sunday Monday Tuesday Wednesday Thursday Friday Saturday", a)
	for (i=1; i<8; i++) a[i-1] = a[i]
	delete a[7]
}

#
# split(s, a[, fs ])
#
# Split the string s into array elements a[1], a[2], ..., a[n], and return n.
# All elements of the array shall be deleted before the split is performed.
# The separation shall be done with the ERE fs or with the field separator FS
# if fs is not given. ...
#
# -- POSIX Specification
#

#

BEGIN {
	initArray(A)

	for (i=21;i<=31;i++)
		printf "%4d/%02d/%02d %s\n", 2019, 12, i, A[dayweek(2019,12,i)]

	for (i=1;i<=11;i++)
		printf "%4d/%02d/%02d %s\n", 2020, 1, i, A[dayweek(2020,1,i)]
}
