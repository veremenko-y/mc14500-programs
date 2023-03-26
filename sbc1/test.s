;
; Test

.include "system.inc"

.macro delay
    .repeat 12,I
    nop0
    .endrepeat
.endmacro

.segment "CODE"
    orc     RR     ; 1 -> RR
    ien     RR     ; enable input
    oen     RR     ; enable output

 
.repeat 8,I
    sto     MEM0+I
    delay
.endrepeat

.repeat 8,I
    stoc     MEM0+I
    delay
.endrepeat

.repeat 8,I
    ld      RR+I
    sto     OUT0+I
.endrepeat
