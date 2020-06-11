\
\	from src/totient.c
\
\	unsigned phi(unsigned)		to	phi
\

private{

: iter  ( x n -- x n )
   >r
   begin
      r@ /
      dup r@ mod 0<>
   until
   r>
;

: step1  ( x x -- t x )
   dup 2 mod 0= if
      2 / swap
      2 iter drop
   then
;

: step2R  ( t x d -- t x d )
   2dup / over >= if
      2dup mod 0= if
                 \ t x d
         >r      \ d | t x
         swap    \ d | x t
         r@ /    \ d | x t/d
         r@ 1- * \ d | x t/d*(d-1)
         swap    \ d | t x
         r>      \ t x d

         iter
      then
      2 +
      recurse
   then
;

: step2L  ( t x d -- t x d )
   begin
      2dup / over >=
   while
      2dup mod 0= if
                 \ t x d
         >r      \ d | t x
         swap    \ d | x t
         r@ /    \ d | x t/d
         r@ 1- * \ d | x t/d*(d-1)
         swap    \ d | t x
         r>      \ t x d

         iter
      then
      2 +
   repeat
;

: step3  ( t x -- t )
   dup 1 > if
      dup 1- -rot / *
   else
      drop
   then
;

}private

: phi  ( x -- x )
   dup step1
   3 step2R drop
   step3
;

privatize
