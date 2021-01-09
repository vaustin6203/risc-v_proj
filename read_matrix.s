.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:
    
    # Prologue
    addi sp, sp, -24 #saving varibales on the stack
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    add s0, a0, x0  #s0 = filename
    add s1, a1, x0  #s1 = num rows pointer
    add s2, a2, x0  #s2 = num columns pointer
    
    add a1, a0, x0  #open file
    add a2, x0, x0
    jal ra, fopen #returns a0 as file descriptor
    addi t0, x0, -1
    beq a0, t0, eof_or_error #call error if a0 = -1
    add s3, a0, x0  # s3 = file discriptor
    
    add a1, s3, x0  #a1 = file descriptor
    add a2, s1, x0
    addi a3, x0, 4
    jal ra, fread   #returns a0 as num bytes read from file
    addi a3, x0, 4
    bne a0, a3, eof_or_error    #call error if a0 != a3
    lw t0, 0(a2)    #t0 = num rows
    sw t0, 0(s1)    #save num rows into s1
    
    add a1, s3, x0
    add a2, s2, x0
    jal ra, fread
    addi a3, x0, 4
    bne a0, a3, eof_or_error
    lw t1, 0(a2)    #t1 = num columns
    sw t1, 0(s2)    #save num columns into s2
    
    mul s4, t0, t1  #s4 = num elems in matrix 
    addi t0, x0, 4
    mul a0, s4, t0
    jal ra, malloc  #returns a0 as pointer to matrix array
    add s0, a0, x0  #s0 = pointer to matrix array
    
    addi t0, x0, 4
    mul a3, s4, t0  #a3 = num bytes stored in matrix array
    add a2, s0, x0  #a2 = pointer to matrix array
    add a1, s3, x0  #a1 = file descriptor
    jal ra, fread
    addi t0, x0, 4
    mul a3, t0, s4  
    bne a0, a3, eof_or_error    #call error if a3 != a0 
    add a2, s0, x0  #reset a2 to point to first elem in matrix array
    mv a0, a2   #a0 = pointer to matrix array
    
    # Epilogue
    add a1, s1, x0  #restore OG values 
    add a2, s2, x0
    
    lw s4, 20(sp)   #restore memory on stack 
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 24
    ret #return

eof_or_error:
    li a1 1
    jal exit2
    