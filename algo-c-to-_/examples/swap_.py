#
#	from src/swap.c
#
#	void swap(int *, int *)		to	swap
#

from swap import swap

a = [ 1.23, 4.56, 7.89 ]

print("{0:.2f} {1:.2f} {2:.2f}\n\t{3} <-> {4} ({5})".format(
    a[0], a[1], a[2], 0, 1, "swap"))
swap(a, 0, 1)

print("{0:.2f} {1:.2f} {2:.2f}\n\t{3} <-> {4} ({5})".format(
    a[0], a[1], a[2], 0, 1, "swap"))
swap(a, 0, 1)

print("{0:.2f} {1:.2f} {2:.2f}\n\t{3} <-> {4} ({5})".format(
    a[0], a[1], a[2], 1, 2, "swap"))
swap(a, 1, 2)

print("{0:.2f} {1:.2f} {2:.2f}\n\t{3} <-> {4} ({5})".format(
    a[0], a[1], a[2], 2, 1, "swap"))
swap(a, 2, 1)

print("{0:.2f} {1:.2f} {2:.2f}".format(a[0], a[1], a[2]))
