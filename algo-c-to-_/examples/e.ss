;
;	from src/e.c
;
;	long double ee(void)	to	e
;

(import (e))

(let* ([p (e)]
       [r (car p)]
       [n (cdr p)])
  (format #t "~f~%~,20f~%~a (~a)~%" r r r n))
