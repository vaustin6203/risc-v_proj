.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
#   a0 is the pointer to the start of m0
#   a1 is the # of rows (height) of m0
#   a2 is the # of columns (width) of m0
#   a3 is the pointer to the start of m1
#   a4 is the # of rows (height) of m1
#   a5 is the # of columns (width) of m1
#   a6 is the pointer to the the start of d
# Returns:
#   None, sets d = matmul(m0, m1)
# =======================================================
matmul:
    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions
    
    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    add s4, a5, x0
    add s5, a6, x0
    add a1, a3, x0
    add a4, a5, x0
    addi a3, x0, 1
    add t0, x0, x0
    add t1, x0, x0
    
outer_loop_start:
    mul t2, s1, a5
    beq t2, t0, outer_loop_end
    jal x0, inner_loop_start

inner_loop_start:
    beq t0, s1, inner_loop_end
    add s6, t0, x0
    add s7, t1, x0
    mv s8, a0
    mv s9, a1
    mv s10, a6
    jal ra, dot
    mv a6, s10
    sw a0, 0(a6)
    lw ra, 0(sp)
    mv a1, s9
    mv a2, s2
    addi a3, x0, 1
    add a5, s4, x0
    add t0, s6, x0
    add t1, s7, x0
    mv a4, a5
    mv a0, s8
    addi t2, x0, 4
    mul t3, t2, a2
    add a0, a0, t3
    mul t2, t2, a5
    add a6, a6, t2
    addi t0, t0, 1
    jal x0, inner_loop_start

inner_loop_end:
    add t0, x0, x0
    addi t1, t1, 1
    beq t1, a5, outer_loop_end
    addi a1, a1, 4
    add a0, s0, x0
    addi t2, x0, 4
    mul t2, t2, t1
    add a6, s5, t2
    jal x0, inner_loop_start

outer_loop_end:
    # Epilogue
    add a0, s0, x0
    add a1, s1, x0
    add a3, s3, x0
    add a4, s2, x0
    add a6, s5, x0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48
    ret

mismatched_dimensions:
    li a1 2
    jal exit2
