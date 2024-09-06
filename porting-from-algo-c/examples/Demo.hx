//
//	from src/complex.c		to	complex
//	from src/e.c			to	e
//	from src/maceps.c		to	machineepsilon
//	from src/{pi1,pi2}.c		to	pi
//
//	from src/egypfrac.c		to	egyptianfraction
//

#if complex
import src.Complex.demo;
#end

#if e
import src.E.demo;
#end

#if machineepsilon
import src.MachineEpsilon.demo;
#end

#if pi
import src.Pi.demo;
#end

//

#if egyptianfraction
import src.EgyptianFraction.demo;
#end

//

function main()
	demo();
