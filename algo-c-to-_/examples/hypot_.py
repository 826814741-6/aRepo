#
#	from src/hypot.c
#
#	double hypot0(double, double)		to	hypot0
#	double hypot1(double, double)		to	hypot1
#	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
#

from hypot import hypot0, hypot1, hypot2

print("{0:.14f} {1:.20f}".format(hypot0(1,2), hypot0(1,2)))
print("{0:.14f} {1:.20f}".format(hypot1(1,2), hypot1(1,2)))
print("{0:.14f} {1:.20f}".format(hypot2(1,2), hypot2(1,2)))

print("{0:.14f} {1:.20f}".format(hypot0(1<<511,1<<512), hypot0(1<<511,1<<512)))
print("{0:.14f} {1:.20f}".format(hypot1(1<<511,1<<512), hypot1(1<<511,1<<512)))
print("{0:.14f} {1:.20f}".format(hypot2(1<<511,1<<512), hypot2(1<<511,1<<512)))
