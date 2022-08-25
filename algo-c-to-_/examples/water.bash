#
#	from src/water.c
#
#	a part of main		to	isMeasurable
#

. "src/water.bash" || exit

printf "Please specify the capacity of the A container. > "
read a
printf "Please specify the capacity of the B container. > "
read b
printf "How much water do you need? > "
read v

if [ "$(isMeasurable $a $b $v)" ]; then
	x=0; y=0

	while [ "$x" -ne "$v" -a "$y" -ne "$v" ]; do
		if [ "$x" -eq "0" ]; then
			x=$a
			printf "(A:%d, B:%d)... A is FULL (tank -> A)\n" $x $y
		elif [ "$y" -eq "$b" ]; then
			y=0
			printf "(A:%d, B:%d)... B is EMPTY (B -> tank)\n" $x $y
		elif [ "$x" -lt "$(($b - $y))" ]; then
			y=$(($y + $x)); x=0
			printf "(A:%d, B:%d)... A is EMPTY (A -> B)\n" $x $y
		else
			x=$(($x - ($b - $y))); y=$b
			printf "(A:%d, B:%d)... B is FULL (A -> B)\n" $x $y
		fi
	done

	[ "$x" -eq "$v" ] && r="A" || r="B"
	printf "Thank you for waiting. Here you are...(%s).\n" $r
else
	printf "I'm afraid I can't measure it with A,B.\n"
fi
