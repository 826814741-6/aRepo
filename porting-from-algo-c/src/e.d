//
//	from src/e.c
//
//	long double ee(void)	to	e
//

double e()
{
    double r = 0;
    double a = 1;
    double n = 1;
    double prev;

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
    import std.stdio : writef;

    double r = e();

    writef("%.14f\n%.18f\n", r, r);
}

//

void main()
{
    demo();
}
