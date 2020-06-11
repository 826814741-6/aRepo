#
#	from src/gcd.c
#
#	int gcd(int, int) ; recursive	to	gcdR
#	int gcd(int, int) ; loop	to	gcdL
#	int ngcd(int, int[])		to	ngcdL
#	ngcdL				to	ngcdR
#

from gcd import gcdL, gcdR, ngcdL, ngcdR

def _t_gcd(a):
    for v in a:
        assert gcdL(v[0], v[1]) == v[2]
        assert gcdR(v[0], v[1]) == v[2]
        assert gcdL(v[0], v[1]) == gcdR(v[0], v[1])
        if v[0] != v[1]:
            assert gcdL(v[1], v[0]) == v[2]
            assert gcdR(v[1], v[0]) == v[2]
        assert gcdL(gcdL(gcdL(v[0], v[1]), v[0]), v[1]) == v[2]
        assert gcdR(gcdR(gcdR(v[0], v[1]), v[0]), v[1]) == v[2]
        assert gcdL(gcdR(gcdL(v[0], v[1]), v[1]), v[0]) == v[2]
        assert gcdR(gcdL(gcdR(v[0], v[1]), v[1]), v[0]) == v[2]

    print("gcdL and gcdR seem to be fine (in {0} samples).".format(len(a)))

def _t_ngcd(a):
    for v in a:
        assert ngcdL(v[0]) == v[1]
        assert ngcdR(v[0]) == v[1]
        assert ngcdL(v[0]) == ngcdR(v[0])

    print("ngcdL and ngcdR seem to be fine (in {0} samples).".format(len(a)))

_t_gcd((
    (11, 121, 11),
    (22, 22, 22),
    (2, 3, 1),
    (2147483647, 2147483647*6700417, 2147483647),
    (67280421310721, 2305843009213693951, 1),
    (2305843009213693951, 2305843009213693951, 2305843009213693951)
))

_t_ngcd((
    ( (), None ),
    # ( (1), 1 ),   # see below
    ( (1,), 1 ),
    # ( (10), 10 ), # see below
    ( (10,), 10 ),
    ( (2, 3), 1),
    ( (22, 22, 22, 22, 22), 22 ),
    ( (11, 22, 33, 44, 55, 66, 77, 88, 99, 110), 11 ),
    ( (2147483647, 2147483647*6700417), 2147483647 ),
    ( (2147483647, 2147483647*6700417, 6700417), 1 ),
    ( (6700417, 2147483647, 2305843009213693951), 1 )
))

#
#   CAUTION: a tuple of (just) one element in Python
#
#       a = (1,) # OK
#       a = (1)  # bad
#
#   > a, b, c = (), (1,), (1, 2)
#   > print(type(a), type(b), type(c))
#   <class 'tuple'> <class 'tuple'> <class 'tuple'>
#
#   > a, b, c = (), (1), (1,2)
#   > print(type(a), type(b), type(c))
#   <class 'tuple'> <class 'int'> <class 'tuple'>
#
#   ... but in List
#
#       a = [1,] # OK
#       a = [1]  # OK
#
#   > a, b, c, d = [], [1], [1,], [1, 2]
#   > a, b, c, d
#   ([], [1], [1], [1, 2])
#   > print(type(a), type(b), type(c), type(d))
#   <class 'list'> <class 'list'> <class 'list'> <class 'list'>
#
#   see:
#   https://stackoverflow.com/a/12876194
#   https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences
#
