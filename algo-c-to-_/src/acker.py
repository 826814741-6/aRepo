#
#	from src/acker.c
#
#	int A(int, int)		to	ack
#

def ack(x, y):
    if x == 0:
        return y+1
    if y == 0:
        return ack(x-1,1)
    return ack(x-1, ack(x,y-1))
