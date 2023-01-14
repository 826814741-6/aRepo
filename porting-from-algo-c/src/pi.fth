\
\	from src/pi1.c
\
\	long double pi(void)	to	machinLike
\
\	from src/pi2.c
\
\	a part of main		to	gaussLegendre (TODO)
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

\ TODO
: gaussLegendre  ( n -- f )
   4
   \ n u |
   1. 1. 2. fsqrt f/ 1.
   \ n u | t b a

   begin
      \ n u | t b a
      fdup prev f! fover f+ 2. f/
      \ n u | a | t b (a+b)/2.
      fswap prev f@ f* fsqrt
      \ n u | a | t a' (b*a fsqrt)
      fswap frot fover prev f@ f- fdup f*
      \ n u | a | b' a' t (a'-a)*(a'-a)
      dup s>d d>f f* f-
      \ n u | a | b' a' t-(a'-a)*(a'-a)*u
      frot frot
      \ n u | a | t' b' a'
      2 + swap 1- swap over 0=
      \ n-1 u+2 (n-1)==0 | a | t' b' a'
   until

   \ n u | a | t b a
   2drop
   \ a | t b a
   f+ fdup f* fswap f/
   \ a | (b+a)*(b+a)/t
;

\
\    a part of src/pi2.c
\
\    int i;
\    double a, b, s, t, last;
\
\    a = 1;  b = 1 / sqrt(2.0);  s = 1;  t = 4;
\    for (i = 0; i < 3; i++) {
\        last = a;  a = (a + b) / 2;  b = sqrt(last * b);
\        s -= t * (a - last) * (a - last);  t *= 2;
\        printf("%16.14f\n", (a + b) * (a + b) / s);
\    }
\
\        |
\        V
\
\    a = 1.; b = 1. / sqrt(2.); t = 1.; u = 4
\
\        prev = a
\        a = (a + b) / 2.
\        b = sqrt(prev * b)
\        t = t - (u * (a - prev) * (a - prev))
\        u = u * 2
\
\    (a + b) * (a + b) / t
\

privatize
