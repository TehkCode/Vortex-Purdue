main:
    addi t0, x0, 15    
    addi t1, x0, 3    
    addi t2, x0, 0
    addi t3, x0, 0
division_loop:
    blt t0, t1, end_of_loop
    sub t0, t0, t1
    addi t2, t2, 1
    jal ra, division_loop
end_of_loop: