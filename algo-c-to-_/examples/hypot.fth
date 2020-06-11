\
\	from src/hypot.c
\
\	double hypot0(double, double)		to	hypot0
\	double hypot1(double, double)		to	hypot1
\	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
\

include src/hypot.fth

fp_precision_max set-precision

: printLC  ( -- )
   s" ( LOOPCOUNT : " type getLC . s" )" type
;

s" 1.0 2.0 hypot0 = " type 1.0 2.0 hypot0 f. 10 emit
s" 1.0 2.0 hypot1 = " type 1.0 2.0 hypot1 f. 10 emit
s" 1.0 2.0 hypot2 = " type 1.0 2.0 hypot2 f. printLC 10 emit
3 setLC
s" 1.0 2.0 hypot2 = " type 1.0 2.0 hypot2 f. printLC 10 emit
2 setLC
s" 1.0 2.0 hypot2 = " type 1.0 2.0 hypot2 f. printLC 10 emit
1 setLC
s" 1.0 2.0 hypot2 = " type 1.0 2.0 hypot2 f. printLC 10 emit
setDefaultLC

: fPow  ( f unsigned -- f )
   1.
   begin
      dup 0>
   while
      fover f*
      1-
   repeat
   fswap fdrop drop
;

2.0 32 fPow 4294967296. f- fabs 1. f< not if
   s" ERROR? Please check fPow." type 10 emit
then

s" 2.0 ^ 512 2.0 ^ 512 hypot0 = " type 2.0 512 fPow fdup hypot0 f. 10 emit
s" 2.0 ^ 512 2.0 ^ 512 hypot1 = " type 2.0 512 fPow fdup hypot1 f. 10 emit
s" 2.0 ^ 512 2.0 ^ 512 hypot2 = " type 2.0 512 fPow fdup hypot2 f. 10 emit
