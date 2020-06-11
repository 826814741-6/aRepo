;
;	from src/hypot.c
;
;	double hypot0(double, double)		to	hypot0
;	double hypot1(double, double)		to	hypot1
;	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
;

(import (hypot))

(format #t "~f ~,20f ~a ~%" (hypot0 1 2) (hypot0 1 2) (hypot0 1 2))
(format #t "~f ~,20f ~a ~%" (hypot1 1 2) (hypot1 1 2) (hypot1 1 2))
(format #t "~f ~,20f ~a ~%" (hypot2 1 2) (hypot2 1 2) (hypot2 1 2))
