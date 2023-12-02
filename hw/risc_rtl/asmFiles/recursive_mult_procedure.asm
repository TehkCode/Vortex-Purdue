# set the address where you want this
# code segment
org 0x0000

main:
    addi $sp, $0, 0xFFFC

    addi $s1,$sp,-4

    addi $s0, $0, 0x0001 #operand_1 
    push $s0
    addi $s0, $0, 0x0002 #operand_2 
    push $s0
    addi $s0, $0, 0x0003 #operand_3 
    push $s0
    addi $s0, $0, 0x0004 #operand_4 
    push $s0
    addi $s0, $0, 0x0005 #operand_5 
    push $s0
    # addi $s0, $0, 0x0000 #operand_6 
    # push $s0

    iterate_stack:
        jal mult
        beq $s1,$sp,done
        j iterate_stack
    done: 
        pop $1      #result in Reg1
        halt

mult: 
    pop $t1  #y
    pop $t0  #x
    addi $t2,$0,0 #p = 0
    loop:
        beq $t1, $0, return  # while(y !=0) {
        addi $t1, $t1, -1    #   y = y - 1;
        add $t2, $t2, $t0    #   p = p + x
        j loop               # }
    return:
        push $t2
        jr $ra
