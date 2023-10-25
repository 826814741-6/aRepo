\
\	from src/tarai.c
\
\	int tarai(int, int, int)	to	tarai
\	tarai				to	tak(*)
\
\	*) https://en.wikipedia.org/wiki/Tak_(function)
\

include src/tarai.fth

s" 10 5 0 tarai = " type 10 5 0 tarai .
s" , 10 5 0 tak = " type 10 5 0 tak . 10 emit

private{

variable C
: incrementC C @ 1+ C ! ;
: initC 0 C ! ;
: getC C @ ;

}private

' incrementC is tarai.counter
initC 10 5 0 tarai drop
s" 10 5 0 tarai : " type getC . 10 emit

' incrementC is tak.counter
initC 10 5 0 tak drop
s" 10 5 0 tak : " type getC . 10 emit

privatize
