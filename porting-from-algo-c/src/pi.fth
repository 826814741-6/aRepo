\
\	from src/pi1.c
\
\	long double pi(void)	to	machinLike
\
\	from src/pi2.c
\
\	a part of main		to	gaussLegendre
\

: machinLike  ( -- f )
   1
   \ k
   16. 5. f/ 0.
   \ k | t p
   begin
      \ k | t p
      fover dup s>d d>f f/ fover f+
      \ k | t p (t/k)+p
      fdup frot f-
      \ k | t p' p'-p
      f0= not
      \ k (p'-p==0 not) | t p'
   while
      \ k | t p'
      fswap -5. 5. f* f/ fswap
      \ k | t/(-5.*5.) p'
      2 +
      \ k+2 | t' p'
   repeat
   \ k | t p
   fswap fdrop drop
   \ p

   1
   \ k | p
   4. 239. f/ fswap
   \ k | t p
   begin
      \ k | t p
      fover dup s>d d>f f/ fover fswap f-
      \ k | t p p-(t/k)
      fdup frot f-
      \ k | t p' p'-p
      f0= not
      \ k (p'-p==0 not) | t p'
   while
      \ k | t p'
      fswap -239. 239. f* f/ fswap
      \ k | t/(-239.*239.) p'
      2 +
      \ k+2 | t' p'
   repeat
   \ k | t p
   fswap fdrop drop
   \ p
;

private{

fvariable prev

}private

: gaussLegendre  ( n -- f )
   4
   \ n t |
   1. 1. 2. fsqrt f/ 1.
   \ n t | s b a
   begin
      \ n t | s b a
      fdup prev f! fover f+ 2. f/
      \ n t | a! | s b (a+b)/2.
      fswap prev f@ f* fsqrt
      \ n t | a@ | s a' (b*a fsqrt)
      fswap frot fover prev f@ f- fdup f*
      \ n t | a@ | b' a' s (a'-a)*(a'-a)
      dup s>d d>f f* f-
      \ n t | b' a' s-(a'-a)*(a'-a)*t.
      frot frot
      \ n t | s' b' a'
      2 * swap 1- swap over 0=
      \ n-1 t*2 (n-1)==0 | s' b' a'
   until
   \ n t | s b a
   2drop
   \ | s b a
   f+ fdup f* fswap f/
   \ | (b+a)*(b+a)/s
;

privatize
