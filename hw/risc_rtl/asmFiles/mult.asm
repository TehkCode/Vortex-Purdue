# set the address where you want this
# code segment
org 0x0000

addi   $sp, $0, 0xFFFC

addi   $s0, $0, 0x006 #operand_1 (x)
push $s0
addi   $s0, $0, 0x0005 #operand_2 (y)
push $s0
jal mull
pop $1    #result in R1

halt

mull:
  pop $t1  #y
  pop $t0  #x
  addi $t2,$t2,0 #product = 0

  loop:
    beq $t1, $0, done   # while(y !=0) { #40
    addi $t1, $t1, -1     #   y = y - 1;
    add $t2, $t2, $t0     #   product = product + x
    j loop                # } 

  done:
    push $t2             # push product 
    jr $ra
