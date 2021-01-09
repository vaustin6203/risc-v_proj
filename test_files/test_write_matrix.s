.import ../write_matrix.s
.import ../utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 , 10, 11, 12 , 13, 14, 15 # MAKE CHANGES HERE
file_path: .asciiz "test_output.bin"

.text
main:
    # Write the matrix to a file
    la a0, file_path	#a0 = pointer to file
    la a1, m0	#a1 = pointer to matrix array
    addi a2, x0, 4	#a2 = num rows
    addi a3, x0, 3	#a3 = num columns
    jal ra, write_matrix

    # Exit the program
    addi a0 x0 10
    ecall
