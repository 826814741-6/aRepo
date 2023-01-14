\
\	from src/rand.c
\
\	int rand(void)		to	rand
\	void srand(unsigned)	to	srand
\
\	divE and modE from
\	https://www.microsoft.com/en-us/research/publication/division-and-modulus-for-computer-scientists/
\

32767 constant RAND_MAX

private{

: divE  ( n d -- q )
   2dup / -rot dup -rot mod
   0< if
      0> if 1- else 1+ then
   else
      drop
   then
;

: modE  ( n d -- r )
   dup -rot mod
   dup 0< if
      swap dup 0> if + else - then
   else
      nip
   then
;

variable next
1 next !

}private

: rand  ( -- n )
   next @ 1103515245 * 12345 +
   dup next !
   65536 divE 32768 modE
;

: srand  ( n -- )
   next !
;

privatize
