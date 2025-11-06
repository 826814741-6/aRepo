#
#  from src/grBMP.c
#
#    void putbytes(FILE *, int, unsigned long)  to  (struct.pack)
#    void gr_dot(int, int, long)                to  BMP; :dot
#    void gr_clear(long)                        to  BMP; :clear(, :rect)
#    void gr_BMP(char *)                        to  BMP; :write
#

import struct

def _header(fh, x, y):
    fh.write(struct.pack(
        "<BBIIIIIIHHIIIIII",
        66, # "B"
        77, # "M"
        x * y * 4 + 54,
        0,
        54,
        40,
        x,
        y,
        1,
        32,
        0,
        x * y * 4,
        3780,
        3780,
        0,
        0
    ))

def _body(fh, x, y, data):
    for i in range(y):
        for j in range(x):
            fh.write(data[i][j])

class BMP:
    def __init__(self, x, y):
        self.X = x
        self.Y = y
        self.data = [list(range(x)) for _ in range(y)]

    def dot(self, x, y, color):
        if x >= 0 and x < self.X and y >= 0 and y < self.Y:
            self.data[y][x] = color

    def rect(self, lX, rX, lY, rY, color):
        for x in range(lX, rX):
            for y in range(lY, rY):
                self.dot(x, y, color)

    def clear(self, color):
        self.rect(0, self.X, 0, self.Y, color)

    def write(self, fh):
        _header(fh, self.X, self.Y)
        _body(fh, self.X, self.Y, self.data)

PRESET_COLOR = {
    "BLACK" : struct.pack("<I", 0x000000),
    "WHITE" : struct.pack("<I", 0xffffff),
    "RED"   : struct.pack("<I", 0xff0000),
    "GREEN" : struct.pack("<I", 0x00ff00),
    "BLUE"  : struct.pack("<I", 0x0000ff)
}

def _demo(path):
    x, y = 640, 400
    bmp = BMP(x, y)

    bmp.rect(0, x//2, 0, y//2, PRESET_COLOR["GREEN"])
    bmp.rect(x//2, x, 0, y//2, PRESET_COLOR["BLUE"])
    bmp.rect(0, x//2, y//2, y, PRESET_COLOR["RED"])
    bmp.rect(x//2, x, y//2, y, PRESET_COLOR["WHITE"])

    with open(path, "wb") as fh:
        bmp.write(fh)

if __name__ == "__main__":
    _demo("results/grBMP-py.bmp")
