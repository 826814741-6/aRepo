#
#	from src/isbn.c
#
#	a part of main		to	isISBN10
#
#	from src/isbn13.c
#
#	a part of main		to	isISBN13
#
#	from src/luhn.c
#
#	a part of main		to	isLuhn
#

def isISBN10(s):
    assert type(s) == type("")
    assert len(s) == 10, "ERROR: ISBN-10 must be just 10-digit."

    t = [0] + [int(c) for c in s[:9]] + [(s[9]=="X" or s[9]=="x") and 10 or int(s[9])]

    for i in range(1, 11):
        t[i] = t[i] + t[i-1]
    for i in range(1, 11):
        t[i] = t[i] + t[i-1]

    return t[10] % 11 == 0

def isISBN13(s):
    assert type(s) == type("")
    assert len(s) == 13, "ERROR: ISBN-13 must be just 13-digit."

    t, w = 0, 1

    for i in range(12, -1, -1):
        t, w = t + w * int(s[i]), 4 - w

    return t % 10 == 0

def isLuhn(s):
    assert type(s) == type("")

    t, w = 0, 1

    for i in range(len(s)):
        d = w * int(s[i])
        t, w = d > 9 and t + d - 9 or t + d, 3 - w

    return t % 10 == 0
