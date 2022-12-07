#
#	Hello, World! in GNU dc
#
#	(salvage from https://pastebin.com/3Q3mqW1A)
#

dc -e "1468369091346906859060166438166794P"

#
#   H   e   l   l   o   ,       W   o   r   l   d   !  \n
#  72 101 108 108 111  44  32  87 111 114 108 100  33  10
#
# $ dc -e "2i 1100001 dP1001Pn1010P"
# a 97
#
# $ dc -e "2i 110000101100001 dP1001Pn1010P"
# aa    24929
#
# $ dc -e "2i 11000010110000101100001 dP1001Pn1010P"
# aaa   6381921
#
# $ dc -e "6381921 256 ~ n9Pn10P"
# 97    24929
#
# $ dc -e "97 256 3 ^* 98 256 2 ^* 99 256 1 ^* 10 256 0 ^* +++P"
# abc
#

dc -e "
	[z0!=y]sl [256li^*lR+sRli1+lxx]sy [sillx]sx
	72 101 108 108 111 44 32 87 111 114 108 100 33 10
	0sR 0lxx lR d n10P P
"

# another approach
dc -e "
	[lilF!=y]sl [256li^*lR+sRli1+lxx]sy [sillx]sx
	72 101 108 108 111 44 32 87 111 114 108 100 33 10
	zsF 0sR 0lxx lR d n10P P
"

# using ? command
printf '72 101 108 108 111 44 32 87 111 114 108 100 33 10' | dc -e "
	[z0!=y]sl [256li^*lR+sRli1+lxx]sy [sillx]sx
	? 0sR 0lxx lR n10P
"
printf 1468369091346906859060166438166794 | dc -e "?P"
