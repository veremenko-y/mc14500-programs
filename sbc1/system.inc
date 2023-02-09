.feature ubiquitous_idents
.feature string_escapes
.setcpu "none"

; 0000 0: NOP0 = No change in registers. RR -> RR. FLG0 high.
; 0001 1: LD   = Data -> RR
; 0010 2: LDC  = !Data -> RR
; 0011 3: AND  = RR * Data -> RR
; 0100 4: ANDC = RR * !Data -> RR
; 0101 5: OR   = RR + Data -> RR
; 0110 6: ORC  = RR + !Data -> RR
; 0111 7: XNOR = RR == Data -> RR
; 1000 8: STO  = Store. RR -> Data. Write high if OEN.
; 1001 9: STOC = Store complement. QRR -> Data. Write high if OEN.
; 1010 A: IEN  = Input enable. D -> IEN.
; 1011 B: OEN  = Output enable. D -> OEN.
; 1100 C: JMP  = Jump. Jump high.
; 1101 D: RTN  = Return. RTN high. 1 -> Skip.
; 1110 E: SKZ  = Skip if zero. 1 -> Skip if RR == 0.
; 1111 F: NOPF = No change in registers. RR -> RR. FLGF high.

.define I_NOP0 0
.define I_LD 1
.define I_LDC 2
.define I_AND 3
.define I_ANDC 4
.define I_OR 5
.define I_ORC 6
.define I_XNOR 7
.define I_STO 8
.define I_STOC 9
.define I_IEN 10
.define I_OEN 11
.define I_JMP 12
.define I_RTN 13
.define I_SKZ 14
.define I_NOPF 15

RR = $0
IN1 = $1
IN2 = $2
IN3 = $3
IN4 = $4
IN5 = $5
IN6 = $6
IN7 = $7

MEM0 = $0
MEM1 = $1
MEM2 = $2
MEM3 = $3
MEM4 = $4
MEM5 = $5
MEM6 = $6
MEM7 = $7

OUT0 = $8
OUT1 = $9
OUT2 = $A
OUT3 = $B
OUT4 = $C
OUT5 = $D
OUT6 = $E
OUT7 = $F


.macro __lit_instr op, addr
    .if (addr > $0F)
        .error "Address overflow"
    .endif
    .byte <(((op) << 4) | ((<(addr)) & $0F))
.endmacro

.macro __instr op, addr
    __lit_instr op, addr
.endmacro

.macro nop0         ; 0000: NOP0 = No change in registers. RR -> RR. FLG0 high.
    __instr I_NOP0, 0
.endmacro
.macro ld addr      ; 0001: LD
    __instr I_LD, addr
.endmacro
.macro ldc addr     ; 0010: LDC
    __instr I_LDC, addr
.endmacro
.macro and addr     ; 0011: AND
    __instr I_AND, addr
.endmacro
.macro andc          ; 0100: ANDC
    __instr I_ANDC, addr
.endmacro
.macro or addr      ; 0101: OR
    __instr I_OR, addr
.endmacro
.macro orc addr      ; 0110: ORC
    __instr I_ORC, addr
.endmacro
.macro xnor addr     ; 0111: XNOR
    __instr I_XNOR, addr
.endmacro
.macro sto addr     ; 1000: STO  = Store. RR -> Data. Write high if OEN.
    __instr I_STO, addr
.endmacro
.macro stoc addr    ; 1001: STOC = Store complement. QRR -> Data. Write high if OEN.
    __instr I_STOC, addr
.endmacro
.macro ien addr     ; 1010: IEN  = Input enable. D -> IEN.
    __instr I_IEN, addr
.endmacro
.macro oen addr     ; 1011: OEN  = Output enable. D -> OEN.
    __instr I_OEN, addr
.endmacro
.macro jmp addr     ; 1100: JMP  = Jump. Jump high.
    __instr I_JMP, addr
.endmacro
.macro rtn          ; 1101: RTN  = Return. RTN high. 1 -> Skip.
    __instr I_RTN, 0
.endmacro
.macro skz          ; 1110: SKZ  = Skip if zero. 1 -> Skip if RR == 0.
    __instr I_SKZ, 0
.endmacro
.macro nopf    ; 1111: NOPF = No change
    __instr I_NOPF, 0
.endmacro
