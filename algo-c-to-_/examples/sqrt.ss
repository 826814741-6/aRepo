;
;	from src/sqrt.c
;
;	double mysqrt(double)		to	f-sqrt
;
;	from src/isqrt.c
;
;	unsigned isqrt(unsigned)	to	i-sqrt
;

(import (nthroot))

(define (fmt i)
  (let ([m (sqrt i)]
        [n (f-sqrt i)])
    (format
      #t
      "(~6a ~a) ~f ~,18f ~a~%(~6a ~a) ~f ~,18f ~a~%"
      'sqrt i m m m 'f-sqrt i n n n)))

(for-each fmt (iota 21))

(newline)

; (let ([i (ash 1 32)]) ; Maybe this will take a lot of time. (*)
(let ([i (ash 1 16)])
  (if (for-all
        (lambda (p)
          (let ([m (car p)] [n (cdr p)])
            (and (<= (* m m) n) (> (* (+ m 1) (+ m 1)) n))))
        (map (lambda (n) (cons (i-sqrt n) n)) (iota i)))
      (format #t "i-sqrt seems to be fine in 0 to ~a-1.~%" i)))

;
;	*) Please choose a number depending on the purpose and situation.
;
;	e.g. a list of elapsed time - running _t_iSqrt(0, n) on my old cheap laptop
;
;	in luajit, n == 1<<28 (2^28):
;
;		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
;		...
;		iSqrt() seems to be fine in 0 to 268435456-1.
;
;		real    0m36.307s
;		user    0m35.889s
;		sys     0m0.015s
;
;	in luajit, n == 1<<32 (2^32):
;
;		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
;		...
;		iSqrt() seems to be fine in 0 to 4294967296-1.
;
;		real    10m0.827s
;		user    10m0.906s
;		sys     0m0.096s
;
;	in lua, n == 1<<28 (2^28)
;
;		$ time LUA_PATH=src/?.lua lua example/sqrt.lua
;		...
;		iSqrt() seems to be fine in 0 to 268435456-1.
;
;		real    4m50.528s
;		user    4m50.730s
;		sys     0m0.021s
;
