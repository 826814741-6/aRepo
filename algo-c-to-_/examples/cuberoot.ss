;
;	from src/cuberoot.c
;
;	double cuberoot(double)		to	f-cbrt1
;	double cuberoot2(double)	to	f-cbrt2
;
;	from src/icubrt.c
;
;	unsigned icubrt(unsigned)	to	i-cbrt
;

(import (nthroot))

(define (fmt j)
  (let*
    ([i (- j 10)]
     [m (f-cbrt1 i)]
     [n (f-cbrt2 i)])
    (format
      #t
      "~3@a ~22,18f ~22,18f ~f~%"
      i m n (abs (- m n)))))

(for-each fmt (iota 21))

(newline)

; (let ([i (ash 1 32)]) ; Maybe this will take a lot of time. (*)
(let ([i (ash 1 16)])
  (if (for-all
        (lambda (p)
          (let ([m (car p)] [n (cdr p)])
            (and (<= (* m m m) n) (> (* (+ m 1) (+ m 1) (+ m 1)) n))))
        (map (lambda (n) (cons (i-cbrt n) n)) (iota i)))
      (format #t "i-cbrt seems to be fine in 0 to ~a-1.~%" i)))

;
;	*) Please choose a number depending on the purpose and situation.
;
;	e.g. a list of elapsed time - running _t_iCbrt(0, n) on my old cheap laptop
;
;	in luajit, n == 1<<28 (2^28):
;
;		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
;		...
;		iCbrt() seems to be fine in 0 to 268435456-1.
;
;		real    0m49.737s
;		user    0m49.516s
;		sys     0m0.036s
;
;	in luajit, n == 1<<32 (2^32):
;
;		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
;		...
;		iCbrt() seems to be fine in 0 to 4294967296-1.
;
;		real    13m32.873s
;		user    13m33.160s
;		sys     0m0.122s
;
;	in lua, n == 1<<28 (2^28)
;
;		$ time LUA_PATH=src/?.lua lua example/cuberoot.lua
;		...
;		iCbrt() seems to be fine in 0 to 268435456-1.
;
;		real    5m9.958s
;		user    5m9.423s
;		sys     0m0.082s
;
