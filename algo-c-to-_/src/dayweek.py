#
#	from src/dayweek.c
#
#	a part of main	to	dayweek, initArray
#

def dayweek(y, m, d):
    if m < 3:
        y, m = y - 1, m + 12
    return (y + y//4 - y//100 + y//400 + (13*m+8)//5 + d) % 7

def initArray():
    return (
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    )
