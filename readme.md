
Description
===========

Graphic routine in assembler (Z80) for drawing circles with ZX Spectrum.


Compiling
=========

The source code is a .asm text file that can be compiled with a z80 assembler
like pasmo http://pasmo.speccy.org/ (you can use other assemblers, but some of
them ignore the ORG directives, so be careful with the relocations). With pasmo
you can generate directly a .tap file ready to be loaded in an spectrum
emulator (http://www.worldofspectrum.org/emulators.html). More about tape file
formats in http://www.worldofspectrum.org/formats.html.


Code Explanation
================

The code contains two main functions: one for drawing pixels and another one for
drawing circles. Also, the file includes an execution example placed at the
address 53000, that draws a set of concentric circles growing in size.

For drawing pixels, two lookup tables are used: tabpow2, with powers of 2, and
tablinidx, with the order of the 192 screen lines (remember that the ZX spectrum
used an interlaced access).

You can invoke the routine by placing the point coordinates at the addresses
50998 and 50999, and jumping to the address 51000

```
POKE 50998, 128
POKE 50999, 88
RANDOMIZE USR 51000
```

To invoke the circle routine, you must place the center coordinates at 51997
and 51998, and the radius at 51999, and then jump to the address 52000.

```
POKE 51997, 128
POKE 51998, 88
POKE 51999, 80
RANDOMIZE USR 52000
```

Running the Test Program
========================

In this video, http://www.youtube.com/watch?v=sdccAInujFU, you can see the
execution of the following code under Spectemu emulator
(http://spectemu.sourceforge.net/), comparing the performance of the two
algorithms.

```
10 FOR i=1 TO 20
20 CIRCLE 128, 80, i
30 NEXT i
40 RANDOMIZE USR 53000
```

