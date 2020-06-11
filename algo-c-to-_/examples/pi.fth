\
\	from src/pi1.c
\
\	long double pi(void)	to	machinLike
\
\	from src/pi2.c
\
\	a part of main		to	gaussLegendre (TODO)
\

include src/pi.fth

fp_precision_max set-precision

s" -------- machinLike:" type 10 emit
machinLike f. 10 emit

s" -------- n gaussLegendre (TODO):" type 10 emit
1 gaussLegendre f. s" (1)" type 10 emit
2 gaussLegendre f. s" (2)" type 10 emit
3 gaussLegendre f. s" (3)" type 10 emit
4 gaussLegendre f. s" (4)" type 10 emit
