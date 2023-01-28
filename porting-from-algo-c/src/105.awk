#
#	from src/105.c
#
#	a part of main		to	guess105
#

function guess105(a, b, c) {
    return (70 * a + 21 * b + 15 * c) % 105
}

#

BEGIN {
	print "Please pick a number 1 through 100."

	printf "...and the remainder of it divided by 3 is > "
	getline a
	printf "...and the remainder of it divided by 5 is > "
	getline b
	printf "...and the remainder of it divided by 7 is > "
	getline c

	print "Thank you for replying. I understand."
	printf "The number you chose is %d, isn't it?\n", guess105(a, b, c)
}
