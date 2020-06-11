;
;	from src/e.c
;
;	long double ee(void)	to	e
;

(library
  (e)
  (export e)
  (import (chezscheme))

  (define (e)
    (letrec
      ([r0 0]
       [a0 1]
       [n0 1]
       [iter
        (lambda (r a n prev)
          (if (= (real->flonum r) (real->flonum prev))
              (cons r n)
              (iter (+ r a) (/ a n) (+ n 1) r)))])
      (iter (+ r0 a0) (/ a0 n0) (+ n0 1) r0))))
