#
#	from src/rand.c
#
#	int rand(void)		to	rand
#	void srand(unsigned)	to	srand
#	rand, srand		to	RAND
#

from rand import rand, RAND

print("-------- rand()")
for _ in range(20):
    for _ in range(8):
        print("{0:8d}".format(rand()), end="")
    print()

print("-------- r.rand()")
r = RAND()
for _ in range(20):
    for _ in range(8):
        print("{0:8d}".format(r.rand()), end="")
    print()
