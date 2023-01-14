\
\	from src/mccarthy.c
\
\	int McCarthy(int)	to	mccarthy91
\

include src/mccarthy.fth
include src/_helper.fth

private{

variable EFLAG
0 EFLAG !
: setError -1 EFLAG ! ;
: isError EFLAG @ ;

}private

: _t_mccarthy91  ( limit start -- )
   dup -rot
   begin
      2dup >
   while
      dup mccarthy91 91 = not if
         s" ERROR: " type dup . dup mccarthy91 . 10 emit
         setError
         exit
      then
      1+
   repeat
   drop swap

   isError not if
      s" mccarthy91 seems to be 91 in " type . s" to " type . 10 emit
   else
      2drop
   then
;

privatize

100 1 10 << -1 * _t_mccarthy91

s" ... and in 101 to 110 are:" type 10 emit

110 101 begin
   2dup >=
while
   dup 4 p dup mccarthy91 .
   1+
repeat 2drop
10 emit
