# algo-c-to-___

[『［改訂新版］C言語による標準アルゴリズム事典』](https://gihyo.jp/book/2018/978-4-7741-9690-9)([サポートページ](https://github.com/okumuralab/algo-c))

のサンプルコードを他言語で書く試みです。大まかなルールとして

- ライセンスは[CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/legalcode) (オリジナルと同様)
- １サンプルファイルに対し(又は複数をまとめて)、１ファイルにおさめて src/ 下に配置
- mainブロック下にある動作確認のコードは、別ファイルに分けて examples/ 下に配置
- 動作確認により生成される画像ファイルなどは results/ 下に配置

に従い作成します。

## 進捗

| src          | dest|
|:------------:|:---:|
| 105.c        | 105.{awk,bash,lua,py} |
| 3dgraph.c    | 3dgraph.{lua,py} |
| 5num.c       | NYI |
| acker.c      | acker.{awk,bash,fth,lua,py,ss} |
| area.c       | NYI |
| arith.c      | NYI |
| atan.c       | atan.lua |
| bernoull.c   | NYI |
| bessel.c     | NYI |
| bfs.c        | NYI |
| bifur.c      | bifur.lua |
| binomial.c   | NYI |
| binormal.c   | binormal.lua |
| bisect.c     | NYI |
| bitio.c      | NYI |
| bsrch.c      | NYI |
| btree.c      | NYI |
| bubsort.c    | NYI |
| cannibal.c   | NYI |
| cardano.c    | NYI |
| ccurve.c     | ccurve.{lua,py} |
| cfint.c      | NYI |
| change.c     | change.{awk,lua,py} |
| chaos.c      | NYI |
| chi2.c       | chisqdist.awk,distribution.lua |
| ci.c         | integral.lua |
| circle.c     | grBMP.lua |
| collatz.c    | NYI |
| combinat.c   | combination.{awk,lua} |
| common.c     | NYI |
| complex.c    | NYI |
| condnum.c    | NYI |
| contain.c    | NYI |
| contfrac.c   | NYI |
| contour.c    | NYI |
| corrcoef.c   | NYI |
| cprimes.c    | NYI |
| crc16.c      | NYI |
| crc16t.c     | NYI |
| crc32.c      | NYI |
| crc32t.c     | NYI |
| crnd.c       | crnd.{lua,luajit} |
| crypt.c      | NYI |
| cuberoot.c   | cuberoot.{awk,gawk},nthroot.{fth,lua,luajit,py,ss} |
| dayweek.c    | dayweek.{awk,lua,py} |
| delta2.c     | NYI |
| dfs.c        | NYI |
| dijkstra.c   | NYI |
| distsort.c   | NYI |
| dragon2.c    | dragoncurve.{lua,py} |
| dragon.c     | dragoncurve.{lua,py} |
| e.c          | e.{awk,bash,fth,lua,py,ss} |
| egypfrac.c   | egyptianfraction.py |
| eigen.c      | NYI |
| ellipse.c    | grBMP.lua |
| endian.c     | NYI |
| epsplot.c    | epsplot.{lua,py} |
| euler.c      | NYI |
| eulerian.c   | eulerian.{awk,bash,fth,lua,py} |
| eval.c       | NYI |
| evalcf.c     | NYI |
| exp.c        | NYI |
| factanal.c   | NYI |
| factoriz.c   | factorize.py |
| factrep.c    | NYI |
| fdist.c      | distribution.lua |
| fft.c        | fft.lua |
| fib.c        | fib.{awk,fth,lua,py,ss} |
| fibonacc.c   | NYI |
| float.c      | NYI |
| fmerge.c     | NYI |
| fracint.c    | NYI |
| fukumen.c    | NYI |
| gamma.c      | gamma.{awk,lua} |
| gasket.c     | sierpinski.lua |
| gauss3.c     | NYI |
| gauss5.c     | NYI |
| gauss.c      | NYI |
| gaussjor.c   | NYI |
| gcd.c        | gcd.{awk,bash,lua,py} |
| gencomb.c    | NYI |
| genperm.c    | NYI |
| gf2fact.c    | NYI |
| gjmatinv.c   | NYI |
| goldsect.c   | NYI |
| gr98.c       | - |
| gray1.c      | NYI |
| gray2.c      | NYI |
| grBMP.c      | grBMP.lua |
| grega.c      | - |
| grj3.c       | - |
| grj3f.c      | - |
| grx.c        | - |
| gseidel.c    | NYI |
| hamming.c    | NYI |
| hanoi.c      | NYI |
| heapsort.c   | NYI |
| hilbert.c    | hilbert.{lua,py} |
| horner.c     | horner.{awk,lua,py} |
| house.c      | NYI |
| huffman.c    | NYI |
| hyperb.c     | NYI |
| hypot.c      | hypot.{awk,fth,lua,py,ss} |
| ibeta.c      | NYI |
| icubrt.c     | cuberoot.{awk,gawk},nthroot.{fth,lua,luajit,py,ss} |
| ifs.c        | NYI |
| igamma.c     | NYI |
| imandel.c    | NYI |
| improve.c    | NYI |
| inssort.c    | NYI |
| intsrch.c    | NYI |
| inv.c        | NYI |
| invr.c       | NYI |
| irandom.c    | NYI |
| isbn13.c     | checkdigit.{lua,py} |
| isbn.c       | checkdigit.{lua,py} |
| ishi1.c      | NYI |
| ishi2.c      | NYI |
| isomer.c     | NYI |
| isqrt.c      | sqrt.{awk,gawk},nthroot.{fth,lua,luajit,py,ss} |
| jacobi.c     | NYI |
| jos1.c       | josephus.{lua,py} |
| jos2.c       | josephus.{lua,py} |
| julia.c      | julia.lua |
| kmp.c        | NYI |
| knapsack.c   | NYI |
| knight.c     | NYI |
| koch.c       | koch.{lua,py} |
| komachi.c    | komachi.lua |
| krnd.c       | NYI |
| lagrange.c   | NYI |
| life.c       | NYI |
| line.c       | grBMP.lua |
| lissaj.c     | lissajouscurve.{lua,py} |
| list1.c      | NYI |
| list2.c      | NYI |
| log.c        | NYI |
| lorenz.c     | lorenz.{lua,py} |
| lu.c         | NYI |
| lucas.c      | NYI |
| luhn.c       | checkdigit.{lua,py} |
| maceps.c     | machineepsilon.lua |
| macrornd.c   | NYI |
| magic4.c     | NYI |
| magicsq.c    | NYI |
| mandel.c     | NYI |
| mapsort.c    | NYI |
| marriage.c   | NYI |
| matinv.c     | NYI |
| matmult.c    | NYI |
| matutil.c    | NYI |
| maxmin.c     | NYI |
| maze.c       | NYI |
| mccarthy.c   | mccarthy.{awk,bash,fth,lua,py,ss} |
| meansd1.c    | NYI |
| meansd2.c    | NYI |
| meansd3.c    | NYI |
| merge.c      | NYI |
| mergsort.c   | NYI |
| monte.c      | montecarlo.lua |
| movebloc.c   | moveblock.{awk,lua,py} |
| mrnd.c       | NYI |
| multiply.c   | multiply.{awk,gawk,bash,fth,lua,luajit,py} |
| multprec.c   | NYI |
| neville.c    | NYI |
| newt1.c      | NYI |
| newt2.c      | NYI |
| newton.c     | NYI |
| nextperm.c   | NYI |
| nim.c        | NYI |
| normal.c     | normal.awk,distribution.lua |
| nqueens.c    | NYI |
| numint.c     | NYI |
| optmult.c    | NYI |
| orddif.c     | NYI |
| partit.c     | NYI |
| permfac.c    | NYI |
| permnum.c    | NYI |
| permsign.c   | NYI |
| pi1.c        | pi.{awk,fth,lua,py,ss} |
| pi2.c        | pi.{awk,fth,lua,py,ss} |
| plotter.c    | NYI |
| poly.c       | NYI |
| polygam.c    | NYI |
| polytope.c   | NYI |
| postfix.c    | NYI |
| poweigen.c   | NYI |
| power.c      | power.{awk,gawk,bash,lua,luajit,py} |
| primes.c     | primes.py |
| primroot.c   | NYI |
| princo.c     | NYI |
| pspline2.c   | NYI |
| pspline.c    | NYI |
| qrdecomp.c   | NYI |
| qsort1.c     | NYI |
| qsort2.c     | NYI |
| quadeq.c     | NYI |
| radconv.c    | NYI |
| radsort.c    | NYI |
| rand.c       | rand.{fth,lua,luajit,py} |
| random.c     | NYI |
| randperm.c   | randperm.lua |
| randvect.c   | NYI |
| rank1.c      | NYI |
| rank2.c      | NYI |
| regress.c    | NYI |
| regula.c     | NYI |
| repdec.c     | NYI |
| rndsamp1.c   | NYI |
| rndsamp2.c   | NYI |
| rndsamp3.c   | NYI |
| rndtest.c    | NYI |
| roundoff.c   | NYI |
| sboymoo.c    | NYI |
| select.c     | NYI |
| seqsrch.c    | NYI |
| shelsort.c   | NYI |
| si.c         | integral.lua |
| sierpin.c    | sierpinski.{lua,py} |
| sieve1.c     | NYI |
| sieve2.c     | NYI |
| simplex.c    | NYI |
| skanji.c     | NYI |
| slctsort.c   | NYI |
| slide.c      | NYI |
| solst.c      | NYI |
| sosrch.c     | NYI |
| spline2.c    | NYI |
| spline.c     | NYI |
| sqrt.c       | sqrt.{awk,gawk},nthroot.{fth,lua,luajit,py,ss} |
| squeeze.c    | NYI |
| srchmat.c    | NYI |
| statutil.c   | NYI |
| stemleaf.c   | NYI |
| stirling.c   | stirling.{awk,bash,fth,lua,py} |
| strmatch.c   | NYI |
| sum.c        | sum.{awk,lua,py} |
| svgplot.c    | svgplot.{lua,py} |
| swap.c       | swap.{awk,gawk,lua,py} |
| sweep.c      | NYI |
| tarai.c      | tarai.{awk,fth,lua,py,ss} |
| tbintree.c   | NYI |
| tdist.c      | distribution.lua |
| tetromin.c   | NYI |
| toposort.c   | NYI |
| totient.c    | totient.{awk,bash,fth,lua,py} |
| tree.c       | NYI |
| treecurv.c   | treecurve.{lua,py} |
| tridiag.c    | NYI |
| trig.c       | NYI |
| trigint.c    | NYI |
| ukanji.c     | NYI |
| ulps.c       | NYI |
| utmult.c     | NYI |
| warshall.c   | NYI |
| water.c      | water.{awk,bash,lua,py} |
| weights.c    | NYI |
| whrnd.c      | whrnd.{lua,py} |
| window.c     | grBMP.c |
| wordcnt.c    | NYI |
| zeta.c       | zeta.{lua,py} |

## 備考

動作の確認には

    GNU/Linux X86_64

    *.awk       nawk(*1)(20200113), mawk-1.3.4-20200106
    *.gawk      gawk-5.0.1
    *.bash      bash-4.3
    *.fth       pForth(*2)-V28
    *.lua       lua-5.4-beta
    *.luajit    luajit-2.0.5
    *.py        micropython-1.12
    *.ss        ChezScheme-9.5.3

    *1) https://github.com/onetrueawk/awk
    *2) https://github.com/philburk/pforth

を使用しています。

Luaは5.3-での動作を想定します。
