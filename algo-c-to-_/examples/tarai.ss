;
;	from src/tarai.c
;
;	int tarai(int, int, int)	to	tarai
;	tarai				to	tak(*)
;
;	*) https://en.wikipedia.org/wiki/Tak_(function)
;

(import (tarai))

(display (format "~s = ~d, ~s = ~d~%"
                 '(tarai 10 5 0) (tarai 10 5 0) '(tak 10 5 0) (tak 10 5 0)))
