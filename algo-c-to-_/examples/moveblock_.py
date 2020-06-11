#
#	from src/movebloc.c
#
#	void reverse(int, int)		to	reverse
#	void rotate(int, int, int)	to	rotate
#

from moveblock import reverse, rotate
from _helper import decrement

#

s = "SUPERCALIFRAGILISTICEXPIALIDOCIOUS"
a = list(s)
n = decrement(len(a))

reverse(a, 0, n)
reverse(a, 0, n)
assert s == "".join(a)

print("".join(a))
for _ in range(17):
    rotate(a, 0, 5, n)
    print("".join(a))
