#
#	from src/power.c
#
#	double ipower(double, int)	to	iPow
#	iPow				to	iPowR
#	double power(double, double)	to	fPow
#

from power import iPow, iPowR, fPow
from _helper import p

print("{0:>23}{1:>18}{2:>18}".format(
    "2**n==iPow(2,n)", "2**n==iPowR(2,n)", "2**n==fPow(2,n)"))

for n in range(-10,11):
    print("{0:>15}{1:>18}{2:>18}".format(
        p(2**n==iPow(2,n)), p(2**n==iPowR(2,n)), p(2**n==fPow(2,n))))

print("{0:>16}{1:>25}{2:>16}".format(
    "2**n", "2**n==fPow(2,n)", "fPow(2,n)"))

for n in range(-10,11):
    print("{0:25.20f}{1:>8}{2:32.20f}".format(
        2**n, p(2**n==fPow(2,n)), fPow(2,n)))
