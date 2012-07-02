
; ZXCircle - Fast circle drawing algorithm
; Copyright 2000-2010, Ibán Cereijo Graña <ibancg at gmail dot com>
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.


    ;; Point (x,y) routine
    org     50998
x:  defb    0       ; coordinates
y:  defb    0

plot:
    push    af
    push    bc
    push    de
    push    hl      ; keep the registers

    ld      hl,tabpow2
    ld      a,(x)
    and     7       ; x mod 8
    ld      b,0
    ld      c,a
    add     hl,bc
    ld      a,(hl)
    ld      e,a     ; e contains one bit set

    ld      hl,tablinidx
    ld      a,(y)
    ld      b,0
    ld      c,a
    add     hl,bc
    ld      a,(hl)      ; table lookup

    ld      h,0
    ld      l,a
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl       ; x32 (16 bits)

    set     6,h         ; adds the screen start address (16384)

    ld      a,(x)
    srl     a
    srl     a
    srl     a           ; x/8.

    or      l
    ld      l,a         ; + x/8.

    ld      a,(hl)
    or      e           ; or = superposition mode.
    ld      (hl),a      ; set the pixel.

    pop     hl
    pop     de
    pop     bc
    pop     af          ; recovers registers.
    ret

    ;; -----------------------------------------------

    ;; Circle (x,y,r) routine

    org     51997
xc: defb    0
yc: defb    0       ; center
rc: defb    0       ; radius

circle:
    push    af
    push    bc
    push    de
    push    hl      ; keep registers.

    ;; (b,c) stores the current arc point coordinates (x,y)
    ld      a,(rc)
    ld      b,a     ; x = r
    ld      c,0     ; y = 0
    ld      hl,0    ; error = 0 (I need 16 bits)

    ld      a,(xc)
    ld      d,a
    ld      a,(yc)
    ld      e,a     ; (d,e) contains the center coordinates (xc, yc)

    ld      a,b
    and     a
    jr      z,outloop   ; if radius = 0, we exit

loop:
    ld      a,d
    add     a,b
    ld      (x),a       ; xo + x
    ld      a,e
    add     a,c
    ld      (y),a       ; yo + y
    call    plot        ; (xo + x, yo + y)

    ld      a,e
    sub     c
    ld      (y),a       ; yo - y
    call    plot        ; (xo + x, yo - y)

    ld      a,d
    sub     b
    ld      (x),a       ; xo - x
    call    plot        ; (xo - x, yo - y)

    ld      a,e
    add     a,c
    ld      (y),a       ; yo + y
    call    plot        ; (xo - x, yo + y)

    ;; ---------------------

    ld      a,d
    add     a,c
    ld      (x),a       ; xo + y
    ld      a,e
    add     a,b
    ld      (y),a       ; yo + x
    call    plot        ; (xo + y, yo + x)

    ld      a,e
    sub     b
    ld      (y),a       ; yo - x
    call    plot        ; (xo + y, yo - x)

    ld      a,d
    sub     c
    ld      (x),a       ; xo - y
    call    plot        ; (xo - y, yo - x)

    ld      a,e
    add     a,b
    ld      (y),a       ; yo + x
    call    plot        ; (xo - y, yo + x)
    ;; -----------------------

    push    bc
    ld      b,0
    add     hl,bc
    add     hl,bc
    inc     hl      ; error += 1 + 2*y
    pop     bc
    inc     c       ; y++

    push    hl
    push    bc
    ld      c,b
    ld      b,0
    scf
    ccf                 ; clear carry flag
    sbc     hl,bc       ; error - x
    dec     hl
    bit     7,h         ; is error - x <= 0 ?
    pop     bc
    pop     hl
    jr      nz,skip1    ; if error - x <= 0, skip

    push    bc
    ld      c,b
    ld      b,0
    scf
    ccf
    sbc     hl,bc
    sbc     hl,bc
    inc     hl
    pop     bc      ; error += 1 - 2*x
    dec     b       ; x--

skip1:

    ld      a,b
    cp      c       ; if y >= x, then exit
    jr      nc,loop

outloop:
    pop     hl
    pop     bc
    pop     de
    pop     af      ; recovers former register values.
    ret

    ;; -------------------------------
    ;; Test program, 90 concentric circles growing in size

    org     53000
    ld      a,128
    ld      (xc),a
    ld      a,96
    ld      (yc),a
    ld      a,1
buc:
    ld      (rc),a
    call    circle
    inc     a
    cp      90
    jr      nz,buc
    ret

    ;; screen lines lookup table
tablinidx:
    defb    0,8,16,24,32,40,48,56,1,9,17,25,33,41,49,57
    defb    2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59
    defb    4,12,20,28,36,44,52,60,5,13,21,29,37,45,53,61
    defb    6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63

    defb    64,72,80,88,96,104,112,120,65,73,81,89,97,105,113,121
    defb    66,74,82,90,98,106,114,122,67,75,83,91,99,107,115,123
    defb    68,76,84,92,100,108,116,124,69,77,85,93,101,109,117,125
    defb    70,78,86,94,102,110,118,126,71,79,87,95,103,111,119,127

    defb    128,136,144,152,160,168,176,184,129,137,145,153,161,169,177,185
    defb    130,138,146,154,162,170,178,186,131,139,147,155,163,171,179,187
    defb    132,140,148,156,164,172,180,188,133,141,149,157,165,173,181,189
    defb    134,142,150,158,166,174,182,190,135,143,151,159,167,175,183,191

tabpow2:
    ;; lookup table with powers of 2
    defb    128,64,32,16,8,4,2,1
