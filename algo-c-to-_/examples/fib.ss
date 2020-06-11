;
;	from src/fib.c
;
;	int fib1(int)		to	fib1
;	int fib2(int)		to	fib2
;	a part of main		to	fib3
;

(import (fib))

(define (fibseq fib n)
  (for-each
    (lambda (n) (format #t " ~a" (fib n)))
    (map 1+ (iota n))))

(fibseq fib1 11)
(newline)

(fibseq fib2 11)
(newline)

(fibseq fib3 11)
(newline)
