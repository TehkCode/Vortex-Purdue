# set the address where you want this
# code segment
#89 cycles with pipeline
#71 cycles with branch prediction

org 0x0000

addi   $t1, $0, 100 #operand_1 (x)
addi   $t2, $0, 3
addi   $t3, $0, 0x48 

iterate_stack:
        jal mult
        beq $t2,$0,done
        addi $t2, $t2, -1     #   y = y - 1;
        j iterate_stack
    done: 
        halt

mult: 
    add $t3,$t3,$0 #p = 0
    loop:
        beq $t1, $0, return   # while(y !=0) {
        addi $t1, $t1, -1     #   y = y - 1;
        j loop               # }
    return:
       jr $ra


