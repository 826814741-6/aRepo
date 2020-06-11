private{

: digits  ( number -- length )
   dup 0= if 1+ exit then
   dup 0< if abs 1 else 0 then
   begin over 0> while 1+ swap 10 / swap repeat
   nip
;

}private

: p  ( number width -- )
   over digits - spaces .
;

privatize

: pH  ( number width -- )
   p s" |" type
;

: header  ( width width limit start -- )
   2dup - 1+ >r rot >r

   rot 2 + dup spaces -rot begin
      2dup >=
   while
      dup r@ p
      1+
   repeat 2drop
   10 emit

   spaces
   2r> 1+ * 1- begin
      dup 0>
   while
      s" -" type
      1-
   repeat drop
   10 emit
;

defer body.fmt0
defer body.fmt1
defer body.setLimit
: body  ( limit start limit start -- )
   2>r
   begin
      2dup >=
   while
      dup body.fmt0
      2r@ body.setLimit begin
         2dup >=
      while
         rot 2dup body.fmt1 -rot 1+
      repeat 2drop
      10 emit
      1+
   repeat
   2r> 2drop 2drop
;
