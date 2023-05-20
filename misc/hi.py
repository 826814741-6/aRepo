#
#	Hello, World! in CPython3/MicroPython
#
#	with something like GNU dc's P command:
#	$ dc -e "1468369091346906859060166438166794P"
#	(see https://github.com/826814741-6/aRepo/blob/main/misc/hi.sh)
#

def P(num):
    a, n = [], num

    while n > 255:
        a.insert(0, chr(n % 256))
        n = n // 256
    a.insert(0, chr(n))

    print("".join(a), end="")

# and some utils

def str_to_num(s):
    r, j = 0, 0

    for i in range(len(s)-1, -1, -1):
        r, j = r + ord(s[i]) * (256 ** j), j + 1

    return r

#

P(1468369091346906859060166438166794)
print(str_to_num("Hello, World!\n"))
