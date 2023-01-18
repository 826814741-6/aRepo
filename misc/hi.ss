;
;	Hello, World! in (Chez) Scheme
;
;	with something like GNU dc's P command:
;	$ dc -e "1468369091346906859060166438166794P"
;	(see https://github.com/nobi56/aRepo/blob/master/misc/hi.sh)
;

;
;	$ scheme --script hi.ss
;	...
;	$ larceny -r5rs hi.ss
;	...
;
;	Probably, in some(most?) cases,
;	you need to import some libraries explicitly to run this fun-script.
;
;(import (scheme base) (scheme write))
;
;	$ larceny -r7rs hi-imported.ss
;	...
;

(define (f n lst)
  (if (> n 255)
      (f (quotient n 256) (cons (integer->char (remainder n 256)) lst))
      (cons (integer->char n) lst)))

(define (P n) (display (list->string (f n '()))))

; and some utils

(define (g n e lst)
  (if (null? lst)
      n
      (g (+ n (* (char->integer (car lst)) (expt 256 e))) (- e 1) (cdr lst))))

(define (s->n s) (g 0 (- (string-length s) 1) (string->list s)))

;

(P 1468369091346906859060166438166794)
(display (s->n "Hello, World!\n"))(newline)
