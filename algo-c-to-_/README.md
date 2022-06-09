# algo-c-to-_

[『［改訂新版］C言語による標準アルゴリズム事典』](https://gihyo.jp/book/2018/978-4-7741-9690-9)([サポートページ](https://github.com/okumuralab/algo-c))

のサンプルコードを他言語で書く試みです。大まかなルールとして

- １サンプルファイルに対し(又は複数をまとめて)、１ファイルにおさめて src/ 下に配置
- mainブロック下にある動作確認のコードは、別ファイルに分けて examples/ 下に配置

に従い作成します。なお、各成果物は、(オリジナルと同様に)[CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/legalcode)とします。

## 対応するコード

| src          | dest|
|:------------:|:---:|
| 105.c        | 105.{awk,bash,lua} |
| 3dgraph.c    | 3dgraph.lua |
| 5num.c       |  |
| acker.c      | acker.{awk,bash,fth,lua,ss} |
| area.c       |  |
| arith.c      |  |
| atan.c       | atan.lua |
| bernoull.c   |  |
| bessel.c     |  |
| bfs.c        |  |
| bifur.c      | bifur.lua |
| binomial.c   |  |
| binormal.c   | binormal.lua |
| bisect.c     |  |
| bitio.c      |  |
| bsrch.c      |  |
| btree.c      |  |
| bubsort.c    |  |
| cannibal.c   |  |
| cardano.c    |  |
| ccurve.c     | ccurve.lua |
| cfint.c      |  |
| change.c     | change.{awk,lua} |
| chaos.c      |  |
| chi2.c       | chisqdist.awk,distribution.lua |
| ci.c         | integral.lua |
| circle.c     | grBMP.lua |
| collatz.c    |  |
| combinat.c   | combination.{awk,lua} |
| common.c     |  |
| complex.c    |  |
| condnum.c    |  |
| contain.c    |  |
| contfrac.c   |  |
| contour.c    |  |
| corrcoef.c   |  |
| cprimes.c    |  |
| crc16.c      |  |
| crc16t.c     |  |
| crc32.c      |  |
| crc32t.c     |  |
| crnd.c       | crnd.{lua,luajit} |
| crypt.c      |  |
| cuberoot.c   | cuberoot.awk,nthroot.{fth,lua,luajit,ss} |
| dayweek.c    | dayweek.{awk,lua} |
| delta2.c     |  |
| dfs.c        |  |
| dijkstra.c   |  |
| distsort.c   |  |
| dragon2.c    | dragoncurve.lua |
| dragon.c     | dragoncurve.lua |
| e.c          | e.{awk,bash,fth,lua,ss} |
| egypfrac.c   |  |
| eigen.c      |  |
| ellipse.c    | grBMP.lua |
| endian.c     |  |
| epsplot.c    | epsplot.lua |
| euler.c      |  |
| eulerian.c   | eulerian.{awk,bash,fth,lua} |
| eval.c       |  |
| evalcf.c     |  |
| exp.c        |  |
| factanal.c   |  |
| factoriz.c   |  |
| factrep.c    |  |
| fdist.c      | distribution.lua |
| fft.c        | fft.lua |
| fib.c        | fib.{awk,fth,lua,ss} |
| fibonacc.c   |  |
| float.c      |  |
| fmerge.c     |  |
| fracint.c    |  |
| fukumen.c    |  |
| gamma.c      | gamma.{awk,lua} |
| gasket.c     | sierpinski.lua |
| gauss3.c     |  |
| gauss5.c     |  |
| gauss.c      |  |
| gaussjor.c   |  |
| gcd.c        | gcd.{awk,bash,lua} |
| gencomb.c    |  |
| genperm.c    |  |
| gf2fact.c    |  |
| gjmatinv.c   |  |
| goldsect.c   |  |
| gr98.c       | - |
| gray1.c      |  |
| gray2.c      |  |
| grBMP.c      | grBMP.lua |
| grega.c      | - |
| grj3.c       | - |
| grj3f.c      | - |
| grx.c        | - |
| gseidel.c    |  |
| hamming.c    |  |
| hanoi.c      |  |
| heapsort.c   |  |
| hilbert.c    | hilbert.lua |
| horner.c     | horner.{awk,lua} |
| house.c      |  |
| huffman.c    |  |
| hyperb.c     |  |
| hypot.c      | hypot.{awk,fth,lua,ss} |
| ibeta.c      |  |
| icubrt.c     | cuberoot.awk,nthroot.{fth,lua,luajit,ss} |
| ifs.c        |  |
| igamma.c     |  |
| imandel.c    |  |
| improve.c    |  |
| inssort.c    |  |
| intsrch.c    |  |
| inv.c        |  |
| invr.c       |  |
| irandom.c    |  |
| isbn13.c     | checkdigit.lua |
| isbn.c       | checkdigit.lua |
| ishi1.c      |  |
| ishi2.c      |  |
| isomer.c     |  |
| isqrt.c      | sqrt.awk,nthroot.{fth,lua,luajit,ss} |
| jacobi.c     |  |
| jos1.c       | josephus.lua |
| jos2.c       | josephus.lua |
| julia.c      | julia.lua |
| kmp.c        |  |
| knapsack.c   |  |
| knight.c     |  |
| koch.c       | koch.lua |
| komachi.c    | komachi.lua |
| krnd.c       |  |
| lagrange.c   |  |
| life.c       |  |
| line.c       | grBMP.lua |
| lissaj.c     | lissajouscurve.lua |
| list1.c      |  |
| list2.c      |  |
| log.c        |  |
| lorenz.c     | lorenz.lua |
| lu.c         |  |
| lucas.c      |  |
| luhn.c       | checkdigit.lua |
| maceps.c     | machineepsilon.lua |
| macrornd.c   |  |
| magic4.c     |  |
| magicsq.c    |  |
| mandel.c     |  |
| mapsort.c    |  |
| marriage.c   |  |
| matinv.c     |  |
| matmult.c    |  |
| matutil.c    |  |
| maxmin.c     |  |
| maze.c       |  |
| mccarthy.c   | mccarthy.{awk,bash,fth,lua,ss} |
| meansd1.c    |  |
| meansd2.c    |  |
| meansd3.c    |  |
| merge.c      |  |
| mergsort.c   |  |
| monte.c      | montecarlo.lua |
| movebloc.c   | moveblock.{awk,lua} |
| mrnd.c       |  |
| multiply.c   | multiply.{awk,bash,fth,lua,luajit} |
| multprec.c   |  |
| neville.c    |  |
| newt1.c      |  |
| newt2.c      |  |
| newton.c     |  |
| nextperm.c   |  |
| nim.c        |  |
| normal.c     | normal.awk,distribution.lua |
| nqueens.c    |  |
| numint.c     |  |
| optmult.c    |  |
| orddif.c     |  |
| partit.c     |  |
| permfac.c    |  |
| permnum.c    |  |
| permsign.c   |  |
| pi1.c        | pi.{awk,fth,lua,ss} |
| pi2.c        | pi.{awk,fth,lua,ss} |
| plotter.c    |  |
| poly.c       |  |
| polygam.c    |  |
| polytope.c   |  |
| postfix.c    |  |
| poweigen.c   |  |
| power.c      | power.{awk,bash,lua,luajit} |
| primes.c     |  |
| primroot.c   |  |
| princo.c     |  |
| pspline2.c   |  |
| pspline.c    |  |
| qrdecomp.c   |  |
| qsort1.c     |  |
| qsort2.c     |  |
| quadeq.c     |  |
| radconv.c    |  |
| radsort.c    |  |
| rand.c       | rand.{fth,lua,luajit} |
| random.c     |  |
| randperm.c   | randperm.lua |
| randvect.c   |  |
| rank1.c      |  |
| rank2.c      |  |
| regress.c    |  |
| regula.c     |  |
| repdec.c     |  |
| rndsamp1.c   |  |
| rndsamp2.c   |  |
| rndsamp3.c   |  |
| rndtest.c    |  |
| roundoff.c   |  |
| sboymoo.c    |  |
| select.c     |  |
| seqsrch.c    |  |
| shelsort.c   |  |
| si.c         | integral.lua |
| sierpin.c    | sierpinski.lua |
| sieve1.c     |  |
| sieve2.c     |  |
| simplex.c    |  |
| skanji.c     |  |
| slctsort.c   |  |
| slide.c      |  |
| solst.c      |  |
| sosrch.c     |  |
| spline2.c    |  |
| spline.c     |  |
| sqrt.c       | sqrt.awk,nthroot.{fth,lua,luajit,ss} |
| squeeze.c    |  |
| srchmat.c    |  |
| statutil.c   |  |
| stemleaf.c   |  |
| stirling.c   | stirling.{awk,bash,fth,lua} |
| strmatch.c   |  |
| sum.c        | sum.{awk,lua} |
| svgplot.c    | svgplot.lua |
| swap.c       | swap.{awk,lua} |
| sweep.c      |  |
| tarai.c      | tarai.{awk,fth,lua,ss} |
| tbintree.c   |  |
| tdist.c      | distribution.lua |
| tetromin.c   |  |
| toposort.c   |  |
| totient.c    | totient.{awk,bash,fth,lua} |
| tree.c       |  |
| treecurv.c   | treecurve.lua |
| tridiag.c    |  |
| trig.c       |  |
| trigint.c    |  |
| ukanji.c     |  |
| ulps.c       |  |
| utmult.c     |  |
| warshall.c   |  |
| water.c      | water.{awk,bash,lua} |
| weights.c    |  |
| whrnd.c      | whrnd.lua |
| window.c     | grBMP.lua |
| wordcnt.c    |  |
| zeta.c       | zeta.lua |

## 備考

動作の確認には

    Windows 11 (21H2)

    *.awk       busybox.exe v1.28.0
    *.bash      busybox.exe v1.28.0
    *.fth       PForth V28-LE/64 (*1)
    *.lua       Lua 5.4.4
    *.luajit    LuaJIT 2.1.0-beta3
    *.ss        ChezScheme-9.5.8

    *1) https://github.com/philburk/pforth

を使用しています。

Luaは5.3-での動作を想定します。
