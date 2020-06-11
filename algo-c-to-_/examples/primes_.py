#
#	from src/primes.py
#
#	void generate_primes(void)	to	primeNumbers
#

from primes import primeNumbers

def p(n, w=10, fmt=lambda e: "{0:5d}".format(e)):
    lst = primeNumbers(n)
    for i in range(0, len(lst), w):
        print("".join(map(fmt, lst[i:i+w])))

p(168)
