#
#	from src/rand.c
#
#	int rand(void)		to	rand
#	void srand(unsigned)	to	srand
#	rand, srand		to	RAND
#

RAND_MAX = 32767

__next = 1

def rand():
    global __next
    __next = __next * 1103515245 + 12345
    return (__next // 65536) % 32768

def srand(seed):
    global __next
    __next = seed

class RAND:
    def __init__(self, seed=1):
        self.next = seed

    def rand(self):
        self.next = self.next * 1103515245 + 12345
        return (self.next // 65536) % 32768

    def srand(self, seed):
        self.next = seed
