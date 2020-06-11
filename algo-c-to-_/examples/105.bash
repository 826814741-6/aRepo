#
#	from src/105.c
#
#	a part of main		to	guess105
#

. "src/105.bash" || exit

printf "Please pick a number 1 through 100.\n"

printf "...and the remainder of it divided by 3 is > "
read a
printf "...and the remainder of it divided by 5 is > "
read b
printf "...and the remainder of it divided by 7 is > "
read c

printf "Thank you for replying. I understand.\n"
printf "The number you chose is %d, isn't it?\n" $(guess105 $a $b $c)
