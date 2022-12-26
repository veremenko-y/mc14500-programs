;
; Hellorld
; Yaroslav Veremenko, December 25, 2022
;
; "Hellorld!" over the UART!
; UART speed depends on the osccilator frequency
;

.include "system.inc"

TX = OUT0

.macro tx_bit_send chr, mask
    .if chr & mask > 0
        sto     TX ; 1
    .else
        stoc    TX ; 0
    .endif
.endmacro

.macro tx_send chr
    stoc    TX     ; 0 - frame start
    tx_bit_send chr, $01
    tx_bit_send chr, $02
    tx_bit_send chr, $04
    tx_bit_send chr, $08
    tx_bit_send chr, $10
    tx_bit_send chr, $20
    tx_bit_send chr, $40
    tx_bit_send chr, $80
    sto     TX     ; 1 - frame end
    nop0           ; wait one more bit
.endmacro

.macro tx_print str
    .repeat 32,I
    .if I < .strlen(str)
    c       .set .strat(str, I)
    tx_send c
    .endif
    .endrepeat
.endmacro

.segment "CODE"
    ; *** init code to enable IEN ***
    orc     RR     ; 1 -> RR
    ien     RR     ; enable input
    oen     RR     ; enable init branch

    ; *** program ***
    orc     RR     ; 1 -> RR
    sto     TX     ; init TX, set stop bit high

    tx_print "Hellorld!\r\n"

    nopf           ; halt
