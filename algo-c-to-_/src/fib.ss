;
;	from src/fib.c
;
;	int fib1(int)		to	fib1
;	int fib2(int)		to	fib2
;	a part of main		to	fib3
;

(library
  (fib)
  (export fib1 fib2 fib3)
  (import (chezscheme))

  (define (fib1 n)
    (floor (+ (/ (expt (/ (+ 1 (sqrt 5)) 2) n) (sqrt 5)) .5)))

  (define (fib2 n)
    (letrec*
      ([step-x
        (lambda (a b x y n)
          (if (odd? n)
              (+ (* a x) (* b y))
              x))]
       [step-y
        (lambda (b c x y n)
          (if (odd? n)
              (+ (* b x) (* c y))
              y))]
       [iter
        (lambda (a b c x y n)
          (if (> n 0)
              (iter
                (+ (* a a) (* b b))
                (* b (+ a c))
                (+ (* b b) (* c c))
                (step-x a b x y n)
                (step-y b c x y n)
                (floor (/ n 2)))
              x))])
      (iter 1 1 0 1 0 (- n 1))))

  (define (fib3 n)
    (letrec
      ([iter
        (lambda (a b c)
          (if (< c n)
              (iter (+ a b) a (+ c 1))
              a))])
      (iter 1 0 1))))
