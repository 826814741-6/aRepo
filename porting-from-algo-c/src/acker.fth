\
\	from src/acker.c
\
\	int A(int, int)		to	ack
\

: ack
   over 0= if nip 1+ exit then
   dup 0= if drop 1- 1 recurse exit then
   over 1- -rot 1- recurse recurse
;
