#
#	from src/eulerian.c
#
#	Eulerian	to	eulerianNumber
#

from eulerian import eulerianNumber
from _helper import tableWriter

import sys

writer = tableWriter(
    ( 0, 10, 1, "L" ),
    ( 0, 10, 1 ),
    ( 3, 8 ),
    ( lambda n: n, lambda n: n, lambda k, n: eulerianNumber(n, k) ),
    ( "d", "d", "d" )
)

writer(sys.stdout)
