#
#	from src/tarai.c
#
#	int tarai(int, int, int)	to	tarai
#	tarai				to	tak(*)
#
#	*) https://en.wikipedia.org/wiki/Tak_(function)
#

from tarai import tarai, tak

def count(x, y, z):
    cnt = { 'N':0, 'C':0 }

    def tN(x, y, z):
        cnt['N'] += 1
        if x <= y:
            return y
        return tN(tN(x-1,y,z), tN(y-1,z,x), tN(z-1,x,y))

    def tC(x, y, z):
        def t(x, y, z):
            cnt['C'] += 1
            if x() <= y():
                return y()
            return t(
                lambda : t(lambda : x()-1, y, z),
                lambda : t(lambda : y()-1, z, x),
                lambda : t(lambda : z()-1, x, y)
            )
        return t(lambda : x, lambda : y, lambda : z)

    tN(x, y, z)
    tC(x, y, z)
    return cnt['N'], cnt['C']

print("{0} = {1:d}, {2} = {3:d}".format(
    "tarai(10,5,0)", tarai(10,5,0), "tak(10,5,0)", tak(10,5,0)))

cntN, cntC = count(10,5,0)

print("{0} : {1:d}, {2} : {3:d}".format(
    "tarai(10,5,0)", cntN, "taraiC(10,5,0)", cntC))
