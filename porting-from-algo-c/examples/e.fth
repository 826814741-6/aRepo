\
\	from src/e.c
\
\	long double ee(void)	to	e
\

include src/e.fth

fp_precision_max set-precision

e f. 10 emit
