\
\	from src/acker.c
\
\	int A(int, int)		to	ack
\

include src/acker.fth

private{

variable C
: incrementC C @ 1+ C ! ;
: initC 0 C ! ;
: getC C @ ;

}private

' incrementC is ack.counter

.( 3 3 ack = )
initC 3 3 ack . .( , ) getC . cr

privatize
