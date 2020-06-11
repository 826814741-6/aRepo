\
\	from src/tarai.c
\
\	int tarai(int, int, int)	to	tarai
\	tarai				to	tak(*)
\
\	*) https://en.wikipedia.org/wiki/Tak_(function)
\

private{

: 3dup  ( x y z -- x y z x y z )
   2>r \ x
   dup \ x x
   2r@ \ x x y z
   rot \ x y z x
   2r> \ x y z x y z
;

: pass ;

}private

defer tarai.counter
: tarai
   tarai.counter
   -rot 2dup <= if nip nip exit then rot
   3dup 1- -rot recurse >r           \ z-1 x y recurse
   3dup -rot 1- -rot recurse >r      \ y-1 z x recurse
   rot 1- -rot recurse r> r> recurse \ x-1 y z recurse (y-1 z x) (z-1 x y) recurse
;
' pass is tarai.counter

: tak
   -rot 2dup <= if 2drop exit then rot
   3dup 1- -rot recurse >r           \ z-1 x y recurse
   3dup -rot 1- -rot recurse >r      \ y-1 z x recurse
   rot 1- -rot recurse r> r> recurse \ x-1 y z recurse (y-1 z x) (z-1 x y) recurse
;

privatize
