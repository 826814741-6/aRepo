\
\	from src/eulerian.c
\
\	Eulerian	to	eulerianNumber
\

: eulerianNumber  ( n k -- x )
   dup 0= if 2drop 1 exit then
   dup 0< >r 2dup <= r> or if 2drop 0 exit then
   dup 1+ -rot 2dup 2dup            \ k+1 n k n k n k
   1- swap 1- swap recurse -rot - * \ n-1 k-1 recurse n-k *
   rot 1- rot recurse rot * +       \ n-1 k recurse k+1 * +
;
