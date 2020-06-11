\
\	from src/mccarthy.c
\
\	int McCarthy(int)	to	mccarthy91
\

: mccarthy91  ( x -- x )
   dup 100 > if 10 - exit then
   11 + recurse recurse
;
