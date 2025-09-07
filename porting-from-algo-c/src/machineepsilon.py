#
#  from src/maceps.c
#
#    a part of main  to  machineEpsilon
#

def machineEpsilon():
    e = 1
    while 1 + e > 1:
        yield e
        e /= 2

#

def _demo():
    FLT_EPSILON = 1.19209290e-07          # from src/float.ie3
    DBL_EPSILON = 2.2204460492503131e-16  # from src/float.ie3

    def fmt(e):
        print(f" {e: <14g} {e + 1: <14g} {(1 + e) - 1: <14g}")

    print(" e              1 + e          (1 + e) - 1")
    print("-------------- -------------- --------------")

    g = machineEpsilon()

    while True:
        e = g.__next__()
        fmt(e)
        if e - FLT_EPSILON <= DBL_EPSILON:
            break

    print("^------- FLT_EPSILON")

    for e in g:
        fmt(e)

if __name__ == '__main__':
    _demo()
