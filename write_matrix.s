.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -24 #saving varibales on the stack
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    add s0, a0, x0	#s0 = filename
    add s1, a1, x0	#s1 = pointer to start of matrix array
    add s2, a2, x0	#s2 = num rows 
    add s3, a3, x0	#s3 = num columns
    
    add a1, a0, x0	#open file
    addi a2, x0, 1
    jal ra, fopen	#returns a0 as file descriptor
    addi t0, x0, -1
    beq a0, t0, eof_or_error
    add s4, a0, x0	#s4 = file descriptor
    
    addi a0, x0, 8  #malloc array for matrix dimensions
    jal ra, malloc	#returns a0 as pointer to array
    sw s2, 0(a0)	#save num rows into array
    sw s3, 4(a0)	#save num columns into array
    mv a2, a0	#a2 = array of matrix dimensions 
    
    add a1, s4, x0	#a1 = file descriptor
    addi a3, x0, 2	#a3 = num elems in dim array
    addi a4, x0, 4	#a4 = size of each elem in bytes
    jal ra, fwrite	#returns a0 as num elems written into file
    addi a3, x0, 2
    bne a0, a3, eof_or_error	#error if a3 != a0
    
    add a1, s4, x0	#a1 = file descriptor
    mul a3, s3, s2	#a3 = num elems in matrix array
    addi a4, x0, 4	#a4 = size of each elem in bytes
    add a2, s1, x0	#a2 = pointer to matrix array
    jal ra, fwrite	#returns a0 as num elems written into file
    mul a3, s3, s2
    bne a0, a3, eof_or_error	#error if a3 != a0
    
    add a1, s4, x0	#a1 = file descriptor
    jal ra, fclose
    bne a0, x0, eof_or_error	#error if a0 != 0
    
    add a0, s0, x0	#retore OG values 
    add a1, s1, x0
    add a2, s2, x0
    add a3, s3, x0
    
    # Epilogue
    lw s4, 20(sp)	#restore momory on the stack
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 24
    ret	#return 

eof_or_error:
    li a1 1
    jal exit2
    