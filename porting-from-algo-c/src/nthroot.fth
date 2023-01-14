\
\	from src/sqrt.c
\
\	double mysqrt(double)		to	fSqrt2
\
\	from src/isqrt.c
\
\	unsigned isqrt(unsigned)	to	iSqrt
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

private{

: atLeastOne  ( f -- f )
   fdup 1. f< if fdrop 1. then
;

}private

: fSqrt2  ( f -- f )
   fdup f0= fover f0< or if fdrop 0. exit then

   fdup atLeastOne

   begin
      \ x t
      fover fover f/ fover f+ 2. f/
      \ x t ((x/t)+t)/2.
      fswap fover fover f<
      \ x t' t | t'<t
   while
      \ x t' t
      fdrop
      \ x t'
   repeat

   \ x t' t
   fswap fdrop fswap fdrop
   \ t
;

: fCbrt1  ( f -- f )
   fdup f0= if fdrop 0. exit then

   fdup f0< fabs atLeastOne fdup

   begin
      \ x t | x<0
      fover fover fdup f* f/ fover 2. f* f+ 3. f/
      \ x t (x/(t*t) + t*2.)/3. | x<0
      fswap fover fover f<
      \ x t' t | x<0 t'<t
   while
      \ x t' t | x<0
      fdrop
      \ x t' | x<0
   repeat

   \ x t' t | x<0
   fswap fdrop fswap fdrop
   \ t | x<0
   if -1. f* then
   \ t
;

: fCbrt2  ( f -- f )
   fdup f0= if fdrop 0. exit then

   fdup f0< fabs atLeastOne fdup

   begin
      \ x t | x<0
      fover fover fover fover fdup fdup f* f* f-
      \ x t x t (x-t*t*t) | x<0
      frot frot fdup fdup 2. f* f*
      \ x t (x-t*t*t) x t t*t*2. | x<0
      frot frot f/ f+ f/ fover f+
      \ x t ((x-t*t*t)/(t*t*2. + x/t))+t | x<0
      fswap fover fover f<
      \ x t' t | x<0 t'<t
   while
      \ x t' t | x<0
      fdrop
      \ x t' | x<0
   repeat

   \ x t' t | x<0
   fswap fdrop fswap fdrop
   \ t | x<0
   if -1. f* then
   \ t
;

privatize

: iSqrt  ( i -- i )
   dup 0= over 0< or if drop 0 exit then

   dup 1
   begin
      2dup >
   while
      1 << swap 1 >> swap
   repeat
   swap drop

   begin
      \ x t
      2dup / over + 1 >>
      \ x t ((x/t)+t)>>1
      2dup >
      \ x t t' t>t'
   while
      \ x t t'
      swap drop
      \ x t'
   repeat

   \ x t t'
   drop nip
   \ t
;

: iCbrt
   dup 0= over 0< or if drop 0 exit then

   dup 1
   begin
      2dup >
   while
      1 << swap 2 >> swap
   repeat
   swap drop

   begin
      \ x t
      2dup dup * / over 2 * + 3 /
      \ x t (x/(t*t) + t*2)/3
      2dup >
      \ x t t' t>t'
   while
      \ x t t'
      swap drop
      \ x t'
   repeat

   \ x t t'
   drop nip
   \ t
;
