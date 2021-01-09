.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 is the pointer to the start of the vector
#   a1 is the # of elements in the vector
# Returns:
#   a0 is the first index of the largest element
# =================================================================
argmax:
    # Prologue
    mv t0, a0
    addi a0, x0, 0
    beq a1, x0, loop_end
    addi t1, x0, 1
    lw t2, 0(t0)
    
loop_start:
    beq t1, a1, loop_end
    addi t0, t0 4
    lw t3, 0(t0)
    beq t2, t3, loop_continue
    blt t3, t2, loop_continue
    add a0, t1, x0
    mv t2, t3
    jal x0, loop_continue

loop_continue:
    addi t1, t1, 1
    jal x0, loop_start

loop_end:
    # Epilogue
    ret
