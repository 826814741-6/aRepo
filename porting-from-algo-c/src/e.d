//
//	from src/e.c
//
//	long double ee(void)	to	e
//

auto e(T)(T zero, T one)
{
    auto r = zero;
    auto a = one;
    auto n = one;
    auto prev = zero;

    do {
        prev = r;
        r += a;
        a /= n;
        n += 1;
    } while (r != prev);

    return r;
}

//

void demo()
{
    import std.math : E;
    import std.stdio : writef;

    double d = e(cast(double) 0, cast(double) 1);
    real r = e(cast(real) 0, cast(real) 1);

    writef("%.14f\n%.20f %a (%s)\n", d, d, d, "double");
    writef("%.14f\n%.20f %a (%s)\n", r, r, r, "real");
    writef("%.14f\n%.20f %a (%s)\n", E, E, E, "std.math.E");
}

//

void main()
{
    demo();
}
