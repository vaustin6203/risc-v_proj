.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
    la s0, file_path    #load address of pointer to filename
    
    addi a0, x0, 4  #malloc space for first int
    jal ra, malloc
    mv a1, a0
    add s1, a1, x0  #s1 = pointer to first int
    
    addi a0, x0, 4  #malloc space for second int
    jal ra, malloc
    mv a2, a0   
    add s2, a2, x0  #s2 = pointer to second int 
    add a1, s1, x0  #reset a1 
    
    mv a0, s0
    jal ra, read_matrix
    
    #print out elems of matrix 
    lw a1, 0(a1)
    lw a2, 0(a2)
    jal ra, print_int_array 

    # Terminate program 
    addi a0, x0, 10
    ecall