\
\	from src/multiply.c
\
\	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
\

private{

: addTto3 rot over + -rot ;

: _A
   begin
      over 2 mod 1 = if addTto3 then
      2 * swap 2 / swap
      over 0=
   until
;

: _B
   begin
      over 1 and 1 = if addTto3 then
      1 lshift swap 1 rshift swap
      over 0=
   until
;

: _C
   over 0<> if
      over 1 and 1 = if addTto3 then
      1 lshift swap 1 rshift swap
      recurse
   then
;

}private

: mulA 0 -rot _A 2drop ;
: mulB 0 -rot _B 2drop ;
: mulC 0 -rot _C 2drop ;

privatize
