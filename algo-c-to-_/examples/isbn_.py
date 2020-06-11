#
#	from src/isbn.c
#
#	a part of main		to	isISBN10
#

from checkdigit import isISBN10

def p(s):
    print("{0} is {1}.".format(s, isISBN10(s) and "valid" or "invalid"))

p("4871483517")
