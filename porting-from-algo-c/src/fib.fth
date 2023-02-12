\
\	from src/fib.c
\
\	int fib1(int)		to	fib1
\	int fib2(int)		to	fib2
\	a part of main		to	fib3
\	fib3			to	fib4
\

: fib1  ( n -- n )
   5. fsqrt 1. f+ 2. f/ s>d d>f f**
   5. fsqrt f/ .5 f+
   f>d d>s
;

private{

variable a
variable b
variable c

}private

: fib2  ( n -- n )
   1- 1 0 rot
   \ x y n-1
   1 a ! 1 b ! 0 c !
   \ x y n | a b c
   begin
      dup 0>
   while
      dup 2 mod 0<> if
         -rot 2dup b @ * swap a @ * +
         \ n y*b+x*a x y
         -rot c @ * swap b @ * +
         \ n x' y*c+x*b
         rot
         \ x' y' n
      then
      b @ dup * c @ dup * +
      \ x' y' n c'
      a @ c @ + b @ *
      \ x' y' n c' b'
      a @ dup * b @ dup * +
      \ x' y' n c' b' a'
      a ! b ! c ! 2/
      \ x' y' n'
   repeat
   \ x y n
   2drop
;

privatize

: fib3  ( n -- n )
   1 0 rot
   \ a b n
   begin
      dup 0>
   while
      1- -rot over + swap rot
      \ b+a a n-1
   repeat
   drop nip
;

private{

: rec  ( a b n -- a b n )
   dup 0> if
      1- -rot over + swap rot
      recurse
   then
;

}private

: fib4  ( n -- n )
   1 0 rot rec
   drop nip
;

privatize
