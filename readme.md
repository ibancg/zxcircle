
## ZXCircle - A fast circle algorithm for ZX Spectrum

Graphic routine in assembler (Z80) for drawing circles with ZX Spectrum.

<img align="right" src="https://ibancg.github.io/images/circle_1.png">

## Compiling and running the code

The source code is a `.asm` text file that can be compiled with a **Z80 assembler**
like [Pasmo](http://pasmo.speccy.org/), and run in a **Spectrum emulator** like
[Spectemu](http://spectemu.sourceforge.net/). You can use other assemblers, but with
_Pasmo_ you can [directly generate a _.tap_ file](http://pasmo.speccy.org/pasmodoc.html),
ready to be loaded in the emulator. Both tools have Debian packages, so
for Debian-based distributions we can install them by:

```console
$ sudo apt-get install pasmo spectemu-x11
```

To run the assembler:

```console
$ pasmo -v --tap zxcircle.asm zxcircle.tap

Loading file: zxcircle.asm in 0
Finished loading file: zxcircle.asm in 235
Entering pass 1
Pass 1 finished
Entering pass 2
Pass 2 finished

```

and then we can load the `.tap` in _Spectemu_:

```console
$ xspect zxcircle.tap
```

and inside Spectemu we will have to type

```
LOAD "" CODE
```

and press `F6` to resume the tape (check other options with `Ctrl+h`).

Now we are ready to run the code. In [this video](http://www.youtube.com/watch?v=sdccAInujFU)
you can see the execution of the following code under _Spectemu_, comparing the performance of
the two algorithms.

```
10 FOR i=1 TO 20
20 CIRCLE 128, 80, i
30 NEXT i
40 RANDOMIZE USR 53000
```

## The Code

The [code](zxcircle.asm) contains two main functions: one for drawing pixels, labeled as `plot`
and another one for drawing circles, labeled `circle`. Also, the file includes an
execution example placed at the address `53000`, that draws a set of concentric
circles growing in size.

For drawing pixels, two lookup tables are used: `tabpow2`, with powers of 2, and
`tablinidx`, with the order of the 192 screen lines (remember that the _ZX Spectrum_
used an interlaced access).

You can invoke the routine by placing the point coordinates at the addresses
`50998` and `50999`, and jumping to the address `51000`

```
POKE 50998, 128
POKE 50999, 88
RANDOMIZE USR 51000
```

To invoke the circle routine, you must place the center coordinates at `51997`
and `51998`, and the radius at `51999`, and then jump to the address `52000`.

```
POKE 51997, 128
POKE 51998, 88
POKE 51999, 80
RANDOMIZE USR 52000
```

## Resources

* Algorithm explanation in [my github.io page](https://ibancg.github.io/A-fast-circle-algorithm-for-ZX-Spectrum/)
* [Eexample video](http://www.youtube.com/watch?v=sdccAInujFU)
