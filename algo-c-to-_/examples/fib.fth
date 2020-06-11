\
\	from src/fib.c
\
\	int fib1(int)		to	fib1
\	int fib2(int)		to	fib2
\	a part of main		to	fib3
\	fib3			to	fib4
\

include src/fib.fth

private{

defer fibseq.fib
: fibseq  ( n -- )
   1
   begin
      2dup >=
   while
      dup fibseq.fib .
      1+
   repeat
   10 emit
;

}private

' fib1 is fibseq.fib
11 fibseq

' fib2 is fibseq.fib
11 fibseq

' fib3 is fibseq.fib
11 fibseq

' fib4 is fibseq.fib
11 fibseq

privatize
