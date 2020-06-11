;
;	from src/sqrt.c
;
;	double mysqrt(double)		to	f-sqrt
;
;	from src/isqrt.c
;
;	unsigned isqrt(unsigned)	to	i-sqrt
;
;	from src/cuberoot.c
;
;	double cuberoot(double)		to	f-cbrt1
;	double cuberoot2(double)	to	f-cbrt2
;
;	from src/icubrt.c
;
;	unsigned icubrt(unsigned)	to	i-cbrt
;

(library
  (nthroot)
  (export f-sqrt f-cbrt1 f-cbrt2 i-sqrt i-cbrt)
  (import (chezscheme))

  (define (at-least-one n)
    (if (< n 1) 1 n))

  (define (pred-lt-f a b)
    (< (real->flonum a) (real->flonum b)))

  (define (pred-lt a b)
    (< a b))

  (define (make-iter0 m n)
    (letrec
      ([iter0
        (lambda (a b)
          (if (> a b)
              (iter0 (floor (/ a m)) (* b n))
              b))])
      iter0))

  (define (make-iter pred step)
    (letrec
      ([iter
        (lambda (t prev)
          (if (pred t prev)
              (iter (step t) t)
              prev))])
      iter))

  (define (f-sqrt x)
    (let*
      ([step (lambda (t) (/ (+ (/ x t) t) 2))]
       [iter (make-iter pred-lt-f step)]
       [t0 (at-least-one x)])
      (if (<= x 0)
          0
          (iter (step t0) t0))))

  (define (f-cbrt1 x)
    (let*
      ([ax (abs x)]
       [step (lambda (t) (/ (+ (/ ax (* t t)) (* 2 t)) 3))]
       [iter (make-iter pred-lt-f step)]
       [t0 (at-least-one (abs x))])
      (cond
        [(= x 0) 0]
        [(> x 0) (iter (step t0) t0)]
        [else (* (iter (step t0) t0) -1)])))

  (define (f-cbrt2 x)
    (let*
      ([ax (abs x)]
       [step (lambda (t) (+ t (/ (- ax (* t t t)) (+ (* 2 t t) (/ ax t)))))]
       [iter (make-iter pred-lt-f step)]
       [t0 (at-least-one (abs x))])
      (cond
        [(= x 0) 0]
        [(> x 0) (iter (step t0) t0)]
        [else (* (iter (step t0) t0) -1)])))

  (define (i-sqrt x)
    (let*
      ([step (lambda (t) (floor (/ (+ (floor (/ x t)) t) 2)))]
       [iter (make-iter pred-lt step)]
       [iter0 (make-iter0 2 2)]
       [t0 (iter0 x 1)])
      (if (<= x 0)
          0
          (iter (step t0) t0))))

  (define (i-cbrt x)
    (let*
      ([step (lambda (t) (floor (/ (+ (floor (/ x (* t t))) (* 2 t)) 3)))]
       [iter (make-iter pred-lt step)]
       [iter0 (make-iter0 4 2)]
       [t0 (iter0 x 1)])
      (if (<= x 0)
          0
          (iter (step t0) t0)))))
