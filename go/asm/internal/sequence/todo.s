#include "textflag.h"

// func Fibonacci(n uint64) uint64
TEXT ·Fibonacci(SB), NOSPLIT, $0
    MOVQ first+0(FP), AX
    XORQ R10, R10
    MOVQ $1, R9

loop:
    CMPQ AX, $0
    JE done

    MOVQ R10, DX
    ADDQ R9, R10
    MOVQ DX, R9

    DECQ AX
    JMP loop

done:
    MOVQ R10, ret+8(FP)
    RET
