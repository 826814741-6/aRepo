#
#	from src/whrnd.c
#
#	void init_rnd(int, int, int)		to	whrnd; .init
#	double rnd(void)			to	whrnd; .__call__
#

class whrnd:
    def __init__(self, x=1, y=1, z=1):
        self.init(x, y, z)

    def init(self, x, y, z):
        self.x, self.y, self.z = x, y, z

    def __call__(self):
        self.x = 171 * (self.x % 177) -  2 * (self.x // 177)
        self.y = 172 * (self.y % 176) - 35 * (self.y // 176)
        self.z = 170 * (self.z % 178) - 63 * (self.z // 178)
        if self.x < 0:
            self.x += 30269
        if self.y < 0:
            self.y += 30307
        if self.z < 0:
            self.z += 30323
        r = self.x / 30269 + self.y / 30307 + self.z / 30323
        while r >= 1:
            r -= 1
        return r
