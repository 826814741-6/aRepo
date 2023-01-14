\
\	from src/rand.c
\
\	int rand(void)		to	rand
\	void srand(unsigned)	to	srand
\
\	divE and modE from
\	https://www.microsoft.com/en-us/research/publication/division-and-modulus-for-computer-scientists/
\

include src/rand.fth
include src/_helper.fth

1 begin
   dup 20 <=
while
   1 begin
      dup 8 <=
   while
      rand 8 p
      1+
   repeat drop
   10 emit
   1+
repeat drop
