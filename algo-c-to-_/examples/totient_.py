#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

from totient import phi
from _helper import tableWriter

import sys

writer = tableWriter(
    ( 1, 10, 1 ),
    ( 0, 19, 1 ),
    ( 4, 4 ),
    ( lambda n: n * 10, lambda n: n, lambda x, y: phi(y * 10 + x) ),
    ( "d", "d", "d" )
)

writer(sys.stdout)
