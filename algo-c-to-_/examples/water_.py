#
#	from src/water.c
#
#	a part of main		to	isMeasurable
#

from water import isMeasurable

a = int(input("Please specify the capacity of the A container > "))
b = int(input("Please specify the capacity of the B container > "))
v = int(input("How much water do you need? > "))

if isMeasurable(a, b, v):
    x, y = 0, 0
    while x != v and y != v:
        if x == 0:
            x = a
            print("(A:{0}, B:{1})... A is FULL (tank -> A)".format(x, y))
        elif y == b:
            y = 0
            print("(A:{0}, B:{1})... B is EMPTY (B -> tank)".format(x, y))
        elif x < b - y:
            x, y = 0, y + x
            print("(A:{0}, B:{1})... A is EMPTY (A -> B)".format(x, y))
        else:
            x, y = x - (b - y), b
            print("(A:{0}, B:{1})... B is FULL (A -> B)".format(x, y))
    print("Thank you for waiting. Here you are...({0})".format(x==v and "A" or "B"))
else:
    print("I'm afraid I can't measure it with A,B.")
