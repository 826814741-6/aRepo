#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
#

from multiply import mulA, mulB, mulC

print("{0}, {1}, {2}, {3} -> {4:d}, {5:d}, {6:.2f}, {7:.2f}".format(
    "2*3", "mulA(2,3)", "2.1*3.1", "mulA(2.1,3.1)", 2*3, mulA(2,3), 2.1*3.1, mulA(2.1,3.1)))
print("{0}, {1}, {2}, {3} -> {4:d}, {5:d}, {6:.2f}, (_CAN'T_CALL_)".format(
    "2*3", "mulB(2,3)", "2.1*3.1", "mulB(2.1,3.1)", 2*3, mulB(2,3), 2.1*3.1))
print("{0}, {1}, {2}, {3} -> {4:d}, {5:d}, {6:.2f}, (_CAN'T_CALL_)".format(
    "2*3", "mulC(2,3)", "2.1*3.1", "mulC(2.1,3.1)", 2*3, mulC(2,3), 2.1*3.1))

#
# MicroPython (probably CPython) refuse to execute bitwise operation with float.
#
#   "2*3", "mulB(2,3)", "2.1*3.1", "mulB(2.1,3.1)", 2*3, mulB(2,3), 2.1*3.1, mulB(2.1,3.1)))
#
# Traceback (most recent call last):
#   File "examples/multiply_.py", line 12, in <module>
#   File "./src//multiply.py", line 18, in mulB
# TypeError: unsupported types for __and__: 'float', 'int'
#
