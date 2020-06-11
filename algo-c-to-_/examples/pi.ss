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

(import (pi))

(format #t "-------- machin-like:~%")
(let ([t (machin-like)])
  (format #t "~f ~,18f~%~a~%" t t t))

(format #t "-------- gauss-legendre n:~%")
(let ([fmt (lambda (t n) (format #t "~f ~,18f~%~a (~a)~%" t t t n))])
  (fmt (gauss-legendre 1) 1)
  (fmt (gauss-legendre 2) 2)
  (fmt (gauss-legendre 3) 3))

(format #t "-------- gauss-legendre-with-sqrt-by-hand n:~%")
; (let ([fmt (lambda (t n) (format #t "~f ~,18f~%~a (~a)~%" t t t n))]) ; too long output
(let ([fmt (lambda (t n) (format #t "~f ~,18f (~a)~%" t t n))])
  (fmt (gauss-legendre-with-sqrt-by-hand 1) 1)
  (fmt (gauss-legendre-with-sqrt-by-hand 2) 2)
  (fmt (gauss-legendre-with-sqrt-by-hand 3) 3))
