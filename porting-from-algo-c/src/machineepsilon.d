//
//	from src/maceps.c
//
//	a part of main		to	machineEpsilon
//

import core.thread : Fiber;

void machineEpsilon(T)(ref T e)
{
    e = 1;
    while (1 + e > 1) {
        Fiber.yield();
        e /= 2;
    }
}

//

void demo()
{
    enum FLT_EPSILON = 1.19209290e-07;          // from src/float.ie3
    enum DBL_EPSILON = 2.2204460492503131e-16;  // from src/float.ie3

    import std.stdio : writef;

    void fmt(T)(T e)
    {
        writef("% -14g % -14g % -14g\n", e, 1 + e, (1 + e) - 1);
    }

    writef(" e              1 + e          (1 + e) - 1\n");
    writef("-------------- -------------- --------------\n");

    double d;
    real r;
    auto fDouble = new Fiber(() => machineEpsilon(d));
    auto fReal = new Fiber(() => machineEpsilon(r));

    while (fDouble.state != Fiber.State.TERM) {
        fDouble.call();
        fReal.call();
        fmt(d);
        if (d - FLT_EPSILON <= DBL_EPSILON)
            break;
    }

    writef("^------- FLT_EPSILON\n");

    while (fDouble.state != Fiber.State.TERM) {
        fDouble.call();
        fReal.call();
        fmt(d);
    }

    writef("v------- continue with another fiber of 'real' type\n");
    // ..., if your env supports the 80 bit Extended Real type.

    while (fReal.state != Fiber.State.TERM) {
        fReal.call();
        fmt(r);
    }
}

//

void main()
{
    demo();
}
