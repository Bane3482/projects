#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
  li s3, 3
  li s4, 4
  li s5, 5
  li s6, 6
  li s7, 7
  li s8, 8
  li s9, 9
  li s10, 10
  li s11, 11
  li a7, SYS_write
  ecall
  j loop

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
  li s3, 9
  li s4, 16
  li s5, 25
  li s6, 36
  li s7, 49
  li s8, 64
  li s9, 81
  li s10, 100
  li s11, 121
  li a7, SYS_write
  ecall
  j loop

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
  mv a2, a1
  li a1, 2
#ifdef SYS_reg
  li a7, SYS_reg
  ecall
#endif
  ret

loop:
  j loop
  ret
