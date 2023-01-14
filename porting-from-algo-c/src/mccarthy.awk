#
#	from src/mccarthy.c
#
#	int McCarthy(int)	to	mccarthy91
#

function mccarthy91(x) {
	if (x > 100)
		return x - 10
	else
		return mccarthy91(mccarthy91(x + 11))
}
