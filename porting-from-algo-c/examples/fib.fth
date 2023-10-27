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

defer sample.fib
: sample  ( n -- )
   1
   begin
      2dup >=
   while
      dup sample.fib .
      1+
   repeat
   10 emit
;

}private

' fib1 is sample.fib
11 sample

' fib2 is sample.fib
11 sample

' fib3 is sample.fib
11 sample

' fib4 is sample.fib
11 sample

privatize
