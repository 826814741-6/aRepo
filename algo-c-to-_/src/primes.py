#
#	from src/primes.py
#
#	void generate_primes(void)	to	primeNumbers
#

def primeNumbers(n):
    if n <= 0:
        return

    lst, x, k = [2 for _ in range(n)], 1, 1

    while k < n:
        x, j = x + 2, 0
        while j < k and x % lst[j] != 0:
            j += 1
        if j == k:
            lst[k] = x
            k += 1

    return lst
