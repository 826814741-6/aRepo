#
#	from src/hypot.c
#
#	double hypot0(double, double)		to	hypot0
#	double hypot1(double, double)		to	hypot1
#	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
#

BEGIN {
	printf "%.14f %.20f\n", hypot0(1,2), hypot0(1,2)
	printf "%.14f %.20f\n", hypot1(1,2), hypot1(1,2)
	printf "%.14f %.20f\n", hypot2(1,2), hypot2(1,2)

	printf "%.14f %.20f\n", hypot0(2^511,2^512), hypot0(2^511,2^512)
	printf "%.14f %.20f\n", hypot1(2^511,2^512), hypot1(2^511,2^512)
	printf "%.14f %.20f\n", hypot2(2^511,2^512), hypot2(2^511,2^512)
}
