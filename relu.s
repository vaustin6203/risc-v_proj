.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 is the pointer to the array
#   a1 is the # of elements in the array
# Returns:
#   None
# ==============================================================================
relu:
    # Prologue
    add t0, x0, x0
    add t3, a0, x0
    add t2, a1, x0

loop_start: 
    beq t0, a1, loop_end
    lw t1, 0(a0)
    bge t1, x0, loop_continue
    sw x0, 0(a0)
    jal x0, loop_continue
    
loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    jal x0, loop_start

loop_end:
    # Epilogue
    add a0, t3, x0
    add a1, t2, x0
    ret
