#
#	from src/luhn.c
#
#	a part of main		to	isLuhn
#

from checkdigit import isLuhn

def p(s):
    print("{0} is {1}.".format(s, isLuhn(s) and "valid" or "invalid"))

p("5555555555554444")
# samples from https://en.wikipedia.org/wiki/Luhn_algorithm
p("79927398713")
p("8961019501234400001")
p("9501234400008")
