def atLeastOne(n):
    return n if n > 1 else 1

def decrement(n):
    return n - 1

def increment(n):
    return n + 1

def p(b):
    return "T" if b else "F"

def rep(s, n):
    return "".join(s for _ in range(n))

#
#   tableWriter(x, y, w, f, vFmt)
#
#   x    : (number, number, number[, "L"])
#   y    : (number, number, number)
#   w    : (number, number)
#   f    : (function, function, function)
#   vFmt : (string, string, string)
#
def tableWriter(x, y, w, f, vFmt):
    padding = rep(" ", w[0] + 2)
    border = rep("-", w[1] * sum(1 for i in range(x[0],x[1]+1,x[2])))

    fmt0 = "{0:" + str(w[0]) + vFmt[0] + "} |"
    fmt1 = "{0:" + str(w[1]) + vFmt[1] + "}"
    fmt2 = "{0:" + str(w[1]) + vFmt[2] + "}"

    isL = len(x) == 4 and x[3] == "L"

    def _writer(fh):
        fh.write(padding)
        for i in range(x[0], x[1]+1, x[2]):
            fh.write(fmt1.format(f[1](i)))
        fh.write("\n" + padding + border + "\n")

        for j in range(y[0], y[1]+1, y[2]):
            fh.write(fmt0.format(f[0](j)))
            for i in range(x[0], (isL and j+1 or x[1]+1), x[2]):
                fh.write(fmt2.format(f[2](i, j)))
            fh.write("\n")

    return _writer
