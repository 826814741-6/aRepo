;
;	from src/mccarthy.c
;
;	int McCarthy(int)	to	mccarthy91
;

(import (mccarthy))

(let*
  ([m (ash 1 10)]
   [n (* m -1)])
  (if (for-all
        (lambda (i) (= (mccarthy91 (+ i n)) 91))
        (iota (+ m 101)))
      (format #t "mccarthy91 seems to be 91 in ~a to 100~%" n)))

(format #t "... and in 101 to 110 are:~%")

(for-each
  (lambda (i) (format #t "~4@a:~a" (+ i 101) (mccarthy91 (+ i 101))))
  (iota 10))
(newline)
