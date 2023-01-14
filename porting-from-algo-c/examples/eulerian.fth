\
\	from src/eulerian.c
\
\	Eulerian	to	eulerianNumber
\

include src/eulerian.fth
include src/_helper.fth

3 constant W0
7 constant W1
0 constant L
10 constant R

: f0 W0 pH ;
: f1 swap eulerianNumber W1 p ;
: sL nip over swap ;

' f0 is body.fmt0
' f1 is body.fmt1
' sL is body.setLimit

W0 W1 R L header
R L R L body
