\
\	from src/totient.c
\
\	unsigned phi(unsigned)		to	phi
\

include src/totient.fth
include src/_helper.fth

4 constant W
1 constant XL
10 constant XR
0 constant YL
19 constant YR

: f0 10 * W pH ;
: f1 10 * + phi W p ;
: sL ;

' f0 is body.fmt0
' f1 is body.fmt1
' sL is body.setLimit

W W XR XL header
YR YL XR XL body
