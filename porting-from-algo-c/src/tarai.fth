\
\	from src/tarai.c
\
\	int tarai(int, int, int)	to	tarai
\	tarai				to	tak(*)
\
\	*) https://en.wikipedia.org/wiki/Tak_(function)
\

: pass ;

defer tarai.counter
: tarai
   tarai.counter
   -rot 2dup <= if nip nip exit then rot
   3dup 1- -rot recurse >r           \ z-1 x y recurse
   3dup -rot 1- -rot recurse >r      \ y-1 z x recurse
   rot 1- -rot recurse r> r> recurse \ x-1 y z recurse (y-1 z x) (z-1 x y) recurse
;
' pass is tarai.counter

defer tak.counter
: tak
   tak.counter
   -rot 2dup <= if 2drop exit then rot
   3dup 1- -rot recurse >r           \ z-1 x y recurse
   3dup -rot 1- -rot recurse >r      \ y-1 z x recurse
   rot 1- -rot recurse r> r> recurse \ x-1 y z recurse (y-1 z x) (z-1 x y) recurse
;
' pass is tak.counter
