#
#	from src/water.c
#
#	a part of main		to	isMeasurable
#

function _gcd(x, y,	t) {
	while (y != 0) {
		t = x % y; x = y; y = t
	}
	return x
}

function isMeasurable(a, b, v) {
	return (v <= a || v <= b) && (v % _gcd(a, b)) == 0
}

#

BEGIN {
	printf "Please specify the capacity of the A container. > "
	getline a
	printf "Please specify the capacity of the B container. > "
	getline b
	printf "How much water do you need? > "
	getline v

	if (isMeasurable(a, b, v)) {
		x = 0; y = 0
		do {
			if (x == 0) {
				x = a
				printf "(A:%d, B:%d)... A is FULL (tank -> A)\n", x, y
			} else if (y == b) {
				y = 0
				printf "(A:%d, B:%d)... B is EMPTY (B -> tank)\n", x, y
			} else if (x < b - y) {
				y += x; x = 0
				printf "(A:%d, B:%d)... A is EMPTY (A -> B)\n", x, y
			} else {
				x -= b - y; y = b
				printf "(A:%d, B:%d)... B is FULL (A -> B)\n", x, y
			}
		} while (x != v && y != v)
		printf "Thank you for waiting. Here you are...(%s).\n", x==v ? "A" : "B"
	} else {
		print "I'm afraid I can't measure it with A,B."
	}
}
