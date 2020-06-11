\
\	from src/multiply.c
\
\	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
\

include src/multiply.fth

.( 2 3 * , 2 3 mulA -> ) 2 3 * . .( , ) 2 3 mulA . cr
.( 2 3 * , 2 3 mulB -> ) 2 3 * . .( , ) 2 3 mulB . cr
.( 2 3 * , 2 3 mulC -> ) 2 3 * . .( , ) 2 3 mulC . cr
