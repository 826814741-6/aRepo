#
#  from src/movebloc.c
#
#    void reverse(int, int)      to  reverse
#    void rotate(int, int, int)  to  rotate
#

#
#  swap(a, i, j) from _helper.awk
#

function reverse(a, i, j) {
	while (i < j) {
		swap(a, i, j)
		i += 1
		j -= 1
	}
}

function rotate(a, left, mid, right) {
	reverse(a, left, mid)
	reverse(a, mid + 1, right)
	reverse(a, left, right)
}

#

#
#  concat(a) from _helper.awk
#

BEGIN {
	s = "SUPERCALIFRAGILISTICEXPIALIDOCIOUS"

	split(s, a, "")

	reverse(a, 1, length(s))
	reverse(a, 1, length(s))

	if (s != concat(a)) {
		printf "ERROR in reverse(): \n%s\n%s (should be)\n", concat(a), s
		exit
	}

	print concat(a)
	for (_ = 0; _ < 17; _++) {
		rotate(a, 1, 6, length(s))
		print concat(a)
	}
}
