.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    # Prologue
    add t0, a2, x0
    lw t1, 0(a0)
    lw t2, 0(a1)
    add t3, x0, x0
    addi t5, x0, 4
    mul t6, a3, t5
    mul t5, a4, t5

loop_start:
    beq t0, x0, loop_end
    mul t4, t1, t2
    add t3, t3, t4
    addi t0, t0, -1
    add a0, a0, t6
    add a1, a1, t5
    lw t1, 0(a0)
    lw t2, 0(a1)
    jal x0, loop_start

loop_end:
    # Epilogue
    mul t4, a2, t5
    addi t6, x0, -1
    mul t4, t4, t6
    add a1, a1, t4
    mv a0, t3
    ret
