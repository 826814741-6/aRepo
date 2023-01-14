\
\	from src/cuberoot.c
\
\	double cuberoot(double)		to	fCbrt1
\	double cuberoot2(double)	to	fCbrt2
\
\	from src/icubrt.c
\
\	unsigned icubrt(unsigned)	to	iCbrt
\

include src/nthroot.fth
include src/_helper.fth

fp_precision_max set-precision

-10. -10 begin
   dup 10 <=
while
   dup 3 p
   fdup fCbrt2 fover fCbrt1 fover fover f- f0=
   f. f. if 9 emit s" T (ret1 ret2 f- f0=)" type then 10 emit
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
   dup iCbrt >r r@ r@ r@ * * over > over r> 1+ dup dup * * >= or if
   \ i (t*t*t>i i>=(t+1)*(t+1)*(t+1) or)

      s" ERROR: " type dup . s" iCbrt" type 10 emit
      setError
      exit
   then

   1+
repeat drop drop

isError not if
   \ s" iCbrt seems to be fine in " type 0 . s" to " type 1 32 << 1- . 10 emit
   s" iCbrt seems to be fine in " type 0 . s" to " type 1 16 << 1- . 10 emit
then

privatize

\
\	*) Please choose a number depending on the purpose and situation.
\
\	e.g. a list of elapsed time - running _t_iCbrt(0, n) on my old cheap laptop
\
\	in luajit, n == 1<<28 (2^28):
\
\		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
\		...
\		iCbrt() seems to be fine in 0 to 268435456-1.
\
\		real    0m49.737s
\		user    0m49.516s
\		sys     0m0.036s
\
\	in luajit, n == 1<<32 (2^32):
\
\		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
\		...
\		iCbrt() seems to be fine in 0 to 4294967296-1.
\
\		real    13m32.873s
\		user    13m33.160s
\		sys     0m0.122s
\
\	in lua, n == 1<<28 (2^28)
\
\		$ time LUA_PATH=src/?.lua lua example/cuberoot.lua
\		...
\		iCbrt() seems to be fine in 0 to 268435456-1.
\
\		real    5m9.958s
\		user    5m9.423s
\		sys     0m0.082s
\
