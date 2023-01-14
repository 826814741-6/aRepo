\
\	from src/hypot.c
\
\	double hypot0(double, double)		to	hypot0
\	double hypot1(double, double)		to	hypot1
\	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
\

: hypot0  ( fx fy -- f )
   fdup f* fswap fdup f* f+ fsqrt
;

: hypot1  ( fx fy -- f )
   fdup f0< if fdrop fabs exit then
   fswap
   fdup f0< if fdrop fabs exit then

   fover fover fabs fswap fabs f< if fswap then
   fdup frot frot f/ fdup f* 1. f+ fsqrt fswap fabs f*
;

private{

4 constant DEFAULT_LOOPCOUNT
variable LOOPCOUNT
DEFAULT_LOOPCOUNT LOOPCOUNT !

}private

: setLC  ( n -- )
   LOOPCOUNT !
;

: setDefaultLC  ( -- )
   DEFAULT_LOOPCOUNT LOOPCOUNT !
;

: getLC  ( -- n )
   LOOPCOUNT @
;

: hypot2  ( fx fy -- f )
   fabs fswap fabs fswap
   fover fover f< if fswap then
   fdup f0= if fdrop exit then

   0 begin
      dup LOOPCOUNT @ <
   while
      fover fover f/ fdup f* fdup 4. f+ f/      \ y x ((y/x)*(y/x))/((y/x)*(y/x)+4.)
      frot fover f* frot frot fover 2. f* f* f+ \ y*t x+t*x*2.
      1+
   repeat drop
   fswap fdrop
;

privatize
