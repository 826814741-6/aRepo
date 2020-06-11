;
;	from src/tarai.c
;
;	int tarai(int, int, int)	to	tarai
;	tarai				to	tak(*)
;
;	*) https://en.wikipedia.org/wiki/Tak_(function)
;

(library
  (tarai)
  (export tarai tak)
  (import (chezscheme))

  (define (tarai x y z)
    (if (<= x y)
        y
        (tarai (tarai (- x 1) y z) (tarai (- y 1) z x) (tarai (- z 1) x y))))

  (define (tak x y z)
    (if (<= x y)
        z
        (tak (tak (- x 1) y z) (tak (- y 1) z x) (tak (- z 1) x y)))))
