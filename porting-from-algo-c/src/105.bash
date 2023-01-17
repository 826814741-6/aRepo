#
#	from src/105.c
#
#	a part of main		to	guess105
#

guess105() {
	printf $(((70 * ${1} + 21 * ${2} + 15 * ${3}) % 105))
}
