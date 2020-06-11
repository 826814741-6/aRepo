#
#	from src/stirling.c
#
#	int Stirling1(int, int)		to	stirling1
#	int Stirling2(int, int)		to	stirling2
#

from stirling import stirling1, stirling2
from _helper import tableWriter

import sys

print("-------- Stirling numbers of the first kind:")

tableWriter(
    ( 0, 10, 1, "L" ),
    ( 0, 10, 1 ),
    ( 3, 8 ),
    ( lambda n: n, lambda n: n, lambda k, n: stirling1(n, k) ),
    ( "d", "d", "d" )
)(sys.stdout)

print("-------- Stirling numbers of the second kind:")

tableWriter(
    ( 0, 10, 1, "L" ),
    ( 0, 10, 1 ),
    ( 3, 8 ),
    ( lambda n: n, lambda n: n, lambda k, n: stirling2(n, k) ),
    ( "d", "d", "d" )
)(sys.stdout)
