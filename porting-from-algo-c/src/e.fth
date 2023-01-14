\
\	from src/e.c
\
\	long double ee(void)	to	e
\

: e  ( -- f )
   1. 1. 0.
   begin
      \ n a r
      fover fover f+ fdup frot f- f0= not
      \ n a a+r | ((a+r-r)==0 not)
   while
      \ n a r'
      frot frot fover f/ fswap 1. f+ fswap frot
      \ n+1 a/n r'
   repeat
   \ n a r
   fswap fdrop fswap fdrop
   \ r
;
