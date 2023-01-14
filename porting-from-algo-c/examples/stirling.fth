\
\	from src/stirling.c
\
\	int Stirling1(int, int)		to	stirling1
\	int Stirling2(int, int)		to	stirling2
\

include src/stirling.fth
include src/_helper.fth

3 constant W0
7 constant W1
0 constant L
10 constant R

: f0 W0 pH ;
: f1 swap stirling1 W1 p ;
: f2 swap stirling2 W1 p ;
: sL nip over swap ;

' f0 is body.fmt0
' f1 is body.fmt1
' sL is body.setLimit

s" -------- Stirling numbers of the first kind:" type 10 emit
W0 W1 R L header
R L R L body

' f2 is body.fmt1

s" -------- Stirling numbers of the second kind:" type 10 emit
W0 W1 R L header
R L R L body
