;
;	from src/mccarthy.c
;
;	int McCarthy(int)	to	mccarthy91
;

(library
  (mccarthy)
  (export mccarthy91)
  (import (chezscheme))

  (define (mccarthy91 x)
    (if (> x 100)
        (- x 10)
        (mccarthy91 (mccarthy91 (+ x 11))))))
