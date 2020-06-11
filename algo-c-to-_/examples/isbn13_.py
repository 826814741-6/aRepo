#
#	from src/isbn13.c
#
#	a part of main		to	isISBN13
#

from checkdigit import isISBN13

def p(s):
    print("{0} is {1}.".format(s, isISBN13(s) and "valid" or "invalid"))

p("9784774196909")
