;
; Adder
; Yaroslav Veremenko, December 11, 2022
;
; Set first 7 bit value using input switches (0-6), and press reset.
; First value will be stored in memory.
; Set second value.
; 8 bit output will be placed in the output register
;
; Bit 0 of memory is used as temporary storage
;

.include "system.inc"

CARRY = MEM0

.segment "CODE"
    ; *** init code to enable IEN ***
    sto     CARRY ; presever RR
    orc     RR    ; 1 -> RR
    ien     RR    ; enable input
    ld      CARRY ; restore RR

    ; *** run once on startup ***
    ldc     RR     ; RR is 0 at reset
    oen     RR     ; enable init branch
    ; load input into memory
.repeat 7,I
    ld      IN1+I
    sto     MEM1+I
.endrepeat

    ; *** main loop ***
    orc     RR    ; 1 -> RR
    oen     RR    ; force enable main loop

    stoc    CARRY ; reset carry

.repeat 7,I
    ; alghorithm from page 87 of handbook
    ld      CARRY
    xnor    MEM1+I
    xnor    IN1+I
    sto     OUT1+I

    ld      IN1+I
    or      CARRY
    and     MEM1+I
    ien     IN1+I
    or      CARRY
    sto     CARRY

    orc     RR
    ien     RR
.endrepeat

    orc     RR    ; 1 -> RR, so init code won't run on the next loop


