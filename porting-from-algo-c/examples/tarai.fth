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

variable C
: incrementC C @ 1+ C ! ;
' incrementC is tarai.counter

0 C ! 10 5 0 tarai drop
s" 10 5 0 tarai : " type C @ . 10 emit
