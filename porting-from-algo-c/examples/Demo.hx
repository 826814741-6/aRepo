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

#if lissajouscurve
import src.LissajousCurve.demo;
#end

#if svgplot
import src.SvgPlot.demo;
#end

//

#if egyptianfraction
import src.EgyptianFraction.demo;
#end

//

function main() {
	demo();
}
