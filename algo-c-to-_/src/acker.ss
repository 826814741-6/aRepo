;
;	from src/acker.c
;
;	int A(int, int)		to	ack
;

(library
  (acker)
  (export ack)
  (import (chezscheme))

  (define (ack x y)
    (cond
      [(= x 0) (+ y 1)]
      [(= y 0) (ack (- x 1) 1)]
      [else (ack (- x 1) (ack x (- y 1)))])))
