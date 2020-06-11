#
#	from src/105.c
#
#	a part of main		to	guess105
#

from _105 import guess105

print("Please pick a number 1 through 100.")

a = int(input("...and the remainder of it divided by 3 is > "))
b = int(input("...and the remainder of it divided by 5 is > "))
c = int(input("...and the remainder of it divided by 7 is > "))

print("Thank you for replying. I understand.")
print("The number you chose is {0}, isn't it?".format(guess105(a, b, c)))
