\
\	from src/sqrt.c
\
\	double mysqrt(double)		to	fSqrt2
\
\	from src/isqrt.c
\
\	unsigned isqrt(unsigned)	to	iSqrt
\

include src/nthroot.fth
include src/_helper.fth

fp_precision_max set-precision

0. 0 begin
   dup 20 <=
while
   dup 3 p s" fsqrt  : " type fdup fsqrt f. 10 emit
   dup 3 p s" fSqrt2 : " type fdup fSqrt2 f. 9 emit

   fdup fsqrt fover fSqrt2 f- f0= if
      s" T "
   else
      s" F "
   then
   type s" (ret1 ret2 f- f0=)" type 10 emit

   1+ 1. f+
repeat drop fdrop

10 emit

private{

variable EFLAG
0 EFLAG !
: setError -1 EFLAG ! ;
: isError EFLAG @ ;

}private

\ 1 32 << 0 begin \ Maybe this will take a lot of time. (*)
1 16 << 0 begin
   2dup >
while
   dup iSqrt >r r@ r@ * over > over r> 1+ dup * >= or if
   \ i (t*t>i i>=(t+1)*(t+1) or)

      s" ERROR: " type dup . s" iSqrt" type 10 emit
      setError
      exit
   then
   1+
repeat drop drop

isError not if
   \ s" iSqrt seems to be fine in " type 0 . s" to " type 1 32 << 1- . 10 emit
   s" iSqrt seems to be fine in " type 0 . s" to " type 1 16 << 1- . 10 emit
then

privatize

\
\	*) Please choose a number depending on the purpose and situation.
\
\	e.g. a list of elapsed time - running _t_iSqrt(0, n) on my old cheap laptop
\
\	in luajit, n == 1<<28 (2^28):
\
\		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
\		...
\		iSqrt() seems to be fine in 0 to 268435456-1.
\
\		real    0m36.307s
\		user    0m35.889s
\		sys     0m0.015s
\
\	in luajit, n == 1<<32 (2^32):
\
\		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
\		...
\		iSqrt() seems to be fine in 0 to 4294967296-1.
\
\		real    10m0.827s
\		user    10m0.906s
\		sys     0m0.096s
\
\	in lua, n == 1<<28 (2^28)
\
\		$ time LUA_PATH=src/?.lua lua example/sqrt.lua
\		...
\		iSqrt() seems to be fine in 0 to 268435456-1.
\
\		real    4m50.528s
\		user    4m50.730s
\		sys     0m0.021s
\
