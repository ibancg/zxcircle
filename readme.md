
## ZXCircle - A fast circle algorithm for ZX Spectrum

Graphic routine in assembler (Z80) for drawing circles with ZX Spectrum.

This code was written in 2000, for pure fun and as just an exercise.

<img align="right" src="https://ibancg.github.io/images/circle_1.png">

## Compiling and running the code

The source code is a `.asm` text file that can be compiled with a **Z80 assembler**
like [Pasmo](http://pasmo.speccy.org/), and run in a **Spectrum emulator** like the
[Qaop/JS](http://torinak.com/qaop) online emulator. You can use other assemblers, but with
_Pasmo_ you can [directly generate a _.tap_ file](http://pasmo.speccy.org/pasmodoc.html),
ready to be loaded in the emulator. For Debian-based distributions we can install it by:

```console
$ sudo apt-get install pasmo
```

Run the assembler with the `--tap` or the `--tapbas`:

```console
$ pasmo -v --tapbas zxcircle.asm zxcircle.tap

Loading file: zxcircle.asm in 0
Finished loading file: zxcircle.asm in 235
Entering pass 1
Pass 1 finished
Entering pass 2
Pass 2 finished

```

Then we can load the `.tap` in _Qaop_ and run the example code:

```
RANDOMIZE USR 53000
```

In [this video](http://www.youtube.com/watch?v=sdccAInujFU)
you can see a performance comparison of both the original and new algorithms.

```
10 FOR i=1 TO 20
20 CIRCLE 128, 80, i
30 NEXT i
40 RANDOMIZE USR 53000
```

You can [try it online with Qaop/JS](http://torinak.com/qaop#l=https://raw.githubusercontent.com/ibancg/zxcircle/master/zxcircle.z80), just run the following command once inside:

```
RUN
```

## A deeper look into the code

The file [zxcircle.asm](zxcircle.asm) contains two main functions: one for drawing pixels, labeled as `plot`,
and another one for drawing circles, labeled `circle`. Also, the file includes an
execution example placed at the address _53000_, that draws a set of concentric
circles growing in size.

For drawing pixels, two lookup tables are used: `tabpow2`, with powers of 2, and
`tablinidx`, with the order of the 192 screen lines (remember that the _ZX Spectrum_
used an interlaced access).

You can invoke the routine by placing the point coordinates at the addresses
_50998_ and _50999_, and jumping to the address _51000_

```
POKE 50998, 128
POKE 50999, 88
RANDOMIZE USR 51000
```

To invoke the circle routine, you must place the center coordinates at _51997_
and _51998_, and the radius at _51999_, and then jump to the address _52000_.

```
POKE 51997, 128
POKE 51998, 88
POKE 51999, 80
RANDOMIZE USR 52000
```

## Resources

* Algorithm explanation in [my github.io page](https://ibancg.github.io/A-fast-circle-algorithm-for-ZX-Spectrum/).
* Example [video](https://youtu.be/sdccAInujFU) running under Spectemu.
* [Try it online with Qaop/JS](http://torinak.com/qaop#l=https://raw.githubusercontent.com/ibancg/zxcircle/master/zxcircle.z80).
