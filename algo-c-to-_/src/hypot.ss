;
;	from src/hypot.c
;
;	double hypot0(double, double)		to	hypot0
;	double hypot1(double, double)		to	hypot1
;	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
;

(library
  (hypot)
  (export hypot0 hypot1 hypot2)
  (import (chezscheme))

  (define (hypot0 x y)
    (sqrt (+ (* x x) (* y y))))

  (define (hypot1 x y)
    (let ([ax (abs x)]
          [ay (abs y)]
          [f (lambda (a b c) (* c (sqrt (+ 1 (* (/ a b) (/ a b))))))])
      (cond
        [(= x 0) ay]
        [(= y 0) ax]
        [(< ax ay) (f x y ay)]
        [else (f y x ax)])))

  (define (iter i n x y)
    (let ([t (/ (* (/ y x) (/ y x))
                (+ 4 (* (/ y x) (/ y x))))])
      (if (< i n)
          (iter (+ i 1) n (+ x (* 2 x t)) (* y t))
          x)))

  (define (hypot2 x y)
    (let ([ax (abs x)]
          [ay (abs y)]
          [f
            (lambda (ax ay)
              (if (= ay 0)
                  ax
                  (iter 0 3 ax ay)))])
      (if (< ax ay)
          (f ay ax)
          (f ax ay)))))
