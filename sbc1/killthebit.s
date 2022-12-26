;
; Kill the Bit game
; Based on idea by Dean McDaniel, May 15, 1975
; Yaroslav Veremenko, December 11, 2022
;
; Original Description
;   Object: Kill the rotating bit. If you miss the lit bit, another
;   bit turns on leaving two bits to destroy. Quickly
;   toggle the switch, don't leave the switch in the up
;   position. Before starting, make sure all the switches
;   are in the down position.
;
; Reference
;   https://altairclone.com/downloads/killbits.pdf
;
; MC14500 Notes
;   7 input switches correspond to bits 1-7 of the output, bit 0 is unused
;   Bit 0 of memory is used as temporary storage
;   Bits 1-7 store state of the display

.include "system.inc"

BIT_I0 = IN1
BIT_I1 = IN2
BIT_I2 = IN3
BIT_I3 = IN4
BIT_I4 = IN5
BIT_I5 = IN6
BIT_I6 = IN7

BIT_O0 = OUT1
BIT_O1 = OUT2
BIT_O2 = OUT3
BIT_O3 = OUT4
BIT_O4 = OUT5
BIT_O5 = OUT6
BIT_O6 = OUT7

TMP   = MEM0
BIT_M0 = MEM1
BIT_M1 = MEM2
BIT_M2 = MEM3
BIT_M3 = MEM4
BIT_M4 = MEM5
BIT_M5 = MEM6
BIT_M6 = MEM7

.macro exchange left, right
    ld      (left)
    sto     TMP
    ld      (right)
    sto     (left)
    ld      TMP
    sto     (right)
.endmacro

.segment "CODE"
    ; *** init code to enable IEN ***
    sto     TMP    ; presever RR
    orc     RR     ; 1 -> RR
    ien     RR     ; enable input
    ld      TMP    ; restore RR

    ; *** run once on startup ***
    ldc     RR     ; RR is 0 at reset
    oen     RR     ; enable init branch
    sto     BIT_M0 ; initialize memory with 1 initial bit

    ; *** main loop ***
    orc     RR     ; 1 -> RR
    oen     RR     ; force enable main loop

    ; display all the bits
.repeat 7,I
    ld      BIT_M0+I
    sto     BIT_O0+I
.endrepeat

    ; xor inputs with memory
.repeat 7,I
    ld      BIT_I0+I
    xnor    BIT_M0+I
    stoc    BIT_M0+I
.endrepeat

    ; rotate data
    ; M[5-I] -> TMP
    ; M[4-I] -> M[5-I]
    ; TMP -> M[4-I]
.repeat 6,I
    exchange BIT_M5-I, BIT_M4-I
.endrepeat
    ; exchange last and first bits
    exchange BIT_M6, BIT_M0

    orc     RR     ; 1 -> RR, so init code won't run on the next loop
