#
#	from src/jos1.c
#
#	a part of main		to	josephusProblem1
#
#	from src/jos2.c
#
#	a part of main		to	josephusProblem2
#

from josephus import josephusProblem1, josephusProblem2

assert josephusProblem1(41, 3) == 31
assert josephusProblem2(41, 3) == 31

n = int(input("How many people are there? (N)> "))
p = int(input("Which one do you choose (per step)? (N (th))> "))

assert josephusProblem1(n, p) == josephusProblem2(n, p)
	
print("The {0}th person survives.".format(josephusProblem1(n, p)))
