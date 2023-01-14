\
\	from src/stirling.c
\
\	int Stirling1(int, int)		to	stirling1
\	int Stirling2(int, int)		to	stirling2
\

: stirling1  ( n k -- a )
   2dup < over 1 < or if 2drop 0 exit then
   2dup = if 2drop 1 exit then

   \ n k
   swap 1-
   \ k n-1
   over 1-
   \ k n-1 k-1
   over swap recurse
   \ k n-1 (n-1 k-1 recurse)
   -rot swap over swap recurse * +
   \ (n-1 k-1 recurse) + (n-1)*(n-1 k recurse)
;

: stirling2  ( n k -- a )
   2dup < over 1 < or if 2drop 0 exit then
   2dup = over 1 = or if 2drop 1 exit then

   \ n k
   swap 1-
   \ k n-1
   over 1-
   \ k n-1 k-1
   over swap recurse
   \ k n-1 (n-1 k-1 recurse)
   -rot over recurse * +
   \ (n-1 k-1 recurse) + k*(n-1 k recurse)
;
