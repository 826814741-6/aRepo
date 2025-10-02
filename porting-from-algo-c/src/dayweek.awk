#
#  from src/dayweek.c
#
#    a part of main  to  dayweek, initArray
#

function dayweek(y, m, d) {
	if (m < 3) { y--; m += 12 }
	return (y + int(y/4) - int(y/100) + int(y/400) + int((13*m+8)/5) + d) % 7
}

function initArray(a,	n) {
	split("Sunday Monday Tuesday Wednesday Thursday Friday Saturday", a)

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

	n = length(a)
	for (i = 0; i < n; i++) {
		a[i] = a[i + 1]
	}
	delete a[n]
}

#

function run(	a, i) {
	initArray(a)

	for (i = 21; i <= 31; i++)
		printf "%4d/%02d/%02d %s\n", 2019, 12, i, a[dayweek(2019, 12, i)]

	for (i = 1; i <= 11; i++)
		printf "%4d/%02d/%02d %s\n", 2020, 1, i, a[dayweek(2020, 1, i)]
}

BEGIN {
	run()
}
