//
//	from src/maceps.c
//
//	a part of main		to	machineEpsilon
//

import core.thread : Fiber;

void machineEpsilon(ref double e) {
    e = 1;
    while (1 + e > 1) {
        Fiber.yield();
        e /= 2;
    }
}

//

import std.stdio : writef;

void fmt(double e) {
    writef("% -14g % -14g % -14g\n", e, 1 + e, (1 + e) - 1);
}

void demo() {
    enum FLT_EPSILON = 1.19209290e-07;          // from src/float.ie3
    enum DBL_EPSILON = 2.2204460492503131e-16;  // from src/float.ie3

    double e;
    auto fiber = new Fiber(() => machineEpsilon(e));

    while (fiber.state != Fiber.State.TERM) {
        fiber.call();
        fmt(e);
        if (e - FLT_EPSILON <= DBL_EPSILON)
            break;
    }

    writef("^------- FLT_EPSILON\n");

    while (fiber.state != Fiber.State.TERM) {
        fiber.call();
        fmt(e);
    }
}

//

void main() {
    demo();
}
