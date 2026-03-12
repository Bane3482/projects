#include "textflag.h"

// func LowerBound(slice []int64, value int64) int64
TEXT ·LowerBound(SB), NOSPLIT, $0
    MOVQ slice_base+0(FP), AX
    MOVQ slice_len+8(FP), R11
    MOVQ value+24(FP), CX
    MOVQ $-1, R10

loop:
    MOVQ R11, R9
    SUBQ R10, R9
    CMPQ R9, $1
    JE done

    MOVQ R11, R9
    SUBQ R10, R9
    SHRQ $1, R9
    ADDQ R10, R9

    CMPQ CX, (AX)(R9*8)
    CMOVQLE R9, R11
    CMOVQGT R9, R10

    JMP loop

done:
    MOVQ R11, ret+32(FP)
    RET
