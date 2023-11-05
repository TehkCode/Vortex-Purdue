# set the address where you want this
# code segment
# Days = CurrentDay + (30 ∗ (CurrentMonth − 1)) + 365 ∗ (CurrentYear − 2000)

org 0x0000

main:
    addi $sp, $0, 0xFFFC

    addi $s7,$sp,-4

    addi $s0, $0, 11 #CurrentDay 
    addi $s1, $0, 01 #CurrentMonth 
    addi $s2, $0, 2023 #CurrentYear 

    addi $s1,$s1,-1 #CurrentMonth − 1
    push $s1
    addi $t0,$0,30  #30
    push $t0
    
    jal mult
    pop $t0         #(30 ∗ (CurrentMonth − 1))
    add $s0,$s0,$t0 #CurrentDay + (30 ∗ (CurrentMonth − 1))

    addi $s2,$s2,-2000  #(CurrentYear − 2000)
    push $s2
    addi $t0,$0,365     #365
    push $t0
    
    jal mult        
    pop $t0         #365 * (CurrentYear − 2000)
    add $1,$s0,$t0  # Days = CurrentDay + (30 ∗ (CurrentMonth − 1)) + 365 ∗ (CurrentYear − 2000)

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
        
 
