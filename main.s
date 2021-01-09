.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    addi t0, x0, 5
    bne t0, a0, wrong_num_args #exit if a0 != 5
    
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    
    lw s0, 4(a1)    #s0 = m0 filename
    lw s1, 8(a1)    #s1 = m1 filename
    lw s2, 12(a1)   #s2 = input filename
    lw s9, 16(a1)   #s9 = output filename
    
    # =====================================
    # LOAD MATRICES
    # =====================================
    
    addi a0, x0, 4
    jal ra, malloc  #returns a0 as pointer to a1
    mv t1, a0   #t1 = a1 pointer
    
    addi a0, x0, 4
    jal ra, malloc  #returns a0 as pointer to a2
    mv a2, a0
    mv a1, t1   
    
    # Load pretrained m0
    add a0, s0, x0  #a0 = m0 filename
    jal ra, read_matrix
    mv s3, a0   #s3 = pointer of m0 array
    mv s4, a1   #s4 = pointer to num rows of m0
    mv s5, a2   #s5 = pointer to num columns of m0
    
    addi a0, x0, 4
    jal ra, malloc  #returns a0 as pointer to a1
    mv t1, a0
    
    addi a0, x0, 4
    jal ra, malloc  #returns a0 as pointer to a2
    mv a2, a0
    mv a1, t1
    
    # Load input matrix
    add a0, s2, x0  #a0 = input filename
    jal ra, read_matrix
    mv s6, a0   #s6 = pointer of input array
    mv s7, a1   #s7 = pointer to num rows of input
    mv s8, a2   #s8 = pointer to num columns of input
    
    lw t0, 0(s4)    #t0 = num_rows m0
    lw t1, 0(s8)    #t1 = num_columns input
    mul a0, t0, t1  #a0 = num_rows m0 * num_columns input
    addi t0, x0, 4
    mul a0, a0, t0  #a0 = num bytes of new matmul array
    jal ra, malloc  #returns a0 as pointer to a6
    mv a6, a0       #a6 = new matmul array
    
    # =====================================
    # RUN LAYERS
    # =====================================
    
    # 1. LINEAR LAYER:    m0 * input
    add a0, s3, x0  #a0 = pointer to m0 array
    lw a1, 0(s4)    #a1 = num_rows of m0
    lw a2, 0(s5)    #a2 = num_columns of m0
    add a3, s6, x0  #a3 = pointer to input array
    lw a4, 0(s7)    #a4 = num_rows of input
    lw a5, 0(s8)    #a5 = num_columns of input
    jal ra, matmul
    mv s7, a1
    mv s8, a5
    
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mul a1, s7, s8 #a1 = num elems in matmul matrix 
    mv a0, a6       #a0 = pointer to matmul array
    jal ra, relu    #mutates matmul matrix
    mv a6, a0   #a6 = mutated matmul array
    mv s6, a6   #s6 = mutated matmul array
    
    addi a0, x0, 4
    jal ra, malloc   #returns a0 as pointer to a1
    mv t1, a0
   
    addi a0, x0, 4
    jal ra, malloc   #returns a0 as pointer to a2
    mv a2, a0
    mv a1, t1
   
   # Load pretrained m1
    add a0, s1, x0   #a0 = m1 filename
    jal ra, read_matrix 
    mv s3, a0    #s3 = pointer of m1 array
    lw s4, 0(a1)    #s4 = pointer to num rows of m1
    lw s5, 0(a2)    #s5 = pointer to num columns of m1
   
    mul a0, s4, s8   #a0 = num elems of scores array
    addi t0, x0 4
    mul a0, a0, t0   #a0 = num bytes of scores array
    jal ra, malloc
    mv a6, a0    #a6 = pointer to scores array
   
   # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    add a0, s3, x0   #a0 = pointer to m1 array
    add a1, s4, x0   #a1 = num_rows of m1
    add a2, s5, x0   #a2 = num_columns of m1
    add a3, s6, x0   #a3 = mutated matmul array
    add a4, s7, x0   #a4 = num_rows of mutated matmul array
    add a5, s8, x0   #a5 = num_columns of mutated matmul array
    jal ra, matmul
    mv s3, a6    #s3 = pointer to scores array
    mv s5, a5    #s5 = num_columns of scores array
                #s4 = num_rows of scores array
  
  # =====================================
  # WRITE OUTPUT
  # =====================================
  
  # Write output matrix
    add a0, s9, x0    #a0 = output filename
    add a1, s3, x0    #a1 = pointer to scores array
    add a2, s4, x0    #a2 = num_rows of scores array
    add a3, s5, x0    #a3 = num_columns of scores array
    jal ra, write_matrix  #writes scores matrix into output file
  
   # =====================================
   # CALCULATE CLASSIFICATION/LABEL
   # =====================================
   
  # Call argmax
    add a0, s3, x0    #a0 = pointer to scores array
    mul a1, s4, s5    #a1 = num elems in scores array
    jal ra, argmax    #returns a0 as index of largest elem in scores
  
  # Print classification
    mv a1, a0  #a1 = max_elem in scores
    jal ra, print_int #print max_elem

    lw s9, 36(sp) #restore space on the stack
    lw s8, 32(sp)
    lw s7, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 40
  
  # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit
  
wrong_num_args:
    li a1, 3
    jal exit2
