;
;	from src/pi1.c
;
;	long double pi(void)	to	machin-like
;
;	from src/pi2.c
;
;	a part of main		to	gauss-legendre
;	gauss-legendre		to	gauss-legendre-with-sqrt-by-hand
;

(library
  (pi)
  (export machin-like gauss-legendre gauss-legendre-with-sqrt-by-hand)
  (import (chezscheme) (nthroot))

  (define (machin-like)
    (letrec
      ([step1
        (lambda (p k t prev)
          (if (= (real->flonum p) (real->flonum prev))
              p
              (step1 (+ p (/ t k)) (+ k 2) (/ t (* -5 5)) p)))]
       [step2
        (lambda (p k t prev)
          (if (= (real->flonum p) (real->flonum prev))
              p
              (step2 (- p (/ t k)) (+ k 2) (/ t (* -239 239)) p)))])
      (let*
        ([p0 0]
         [k0 1]
         [t0 (/ 16 5)]
         [p1 (step1 (+ p0 (/ t0 k0)) (+ k0 2) (/ t0 (* -5 5)) p0)]
         [k1 1]
         [t1 (/ 4 239)])
        (step2 (- p1 (/ t1 k1)) (+ k1 2) (/ t1 (* -239 239)) p1))))

  (define (gauss-legendre n)
    (letrec
      ([step-a
        (lambda (a b)
          (/ (+ a b) 2))]
       [step-t
        (lambda (a b t u)
          (- t (* u (- (step-a a b) a) (- (step-a a b) a))))]
       [iter
        (lambda (a b t u i)
          (if (< i n)
              (iter (step-a a b) (sqrt (* a b)) (step-t a b t u) (* u 2) (+ i 1))
              (/ (* (+ a b) (+ a b)) t)))])
      (iter 1 (/ 1 (sqrt 2)) 1 4 0)))

  (define (gauss-legendre-with-sqrt-by-hand n)
    (letrec
      ([step-a
        (lambda (a b)
          (/ (+ a b) 2))]
       [step-t
        (lambda (a b t u)
          (- t (* u (- (step-a a b) a) (- (step-a a b) a))))]
       [iter
        (lambda (a b t u i)
          (if (< i n)
              (iter (step-a a b) (f-sqrt (* a b)) (step-t a b t u) (* u 2) (+ i 1))
              (/ (* (+ a b) (+ a b)) t)))])
      (iter 1 (/ 1 (f-sqrt 2)) 1 4 0))))
