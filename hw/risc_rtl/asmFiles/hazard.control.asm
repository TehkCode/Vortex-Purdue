
org 0x0000

ori $7, $0, 0x0094
ori $10, $0, 0x0001
sw  $10, 0($7)  # No NOP till this point because they are independent or dependency is covered by independent instructions
ori $8, $0, 0x0004
ori $9, $0, 0x0004
beq $8, $9, BEQ_True
ori $10, $0, 0x0004
sw  $10, 0($7)  # No NOP till this point because they are independent or dependency is covered by independent instructions


BEQ_True:
    ori $10, $0, 0x0002
    sw  $10, 0($7)  # No NOP till this point because they are independent or dependency is covered by independent instructions
    ori $11, $0, 0x0004
    ori $12, $0, 0x0002
    bne $11, $12, BNE_True
    ori $10, $0, 0x0005
    sw  $10, 0($7)  # No NOP till this point because they are independent or dependency is covered by independent instructions

    
BNE_True:
   ori $10, $0, 0x0003
   sw  $13, 0($7)
   halt
# Result interpretation
# $8 == $9 -> $10 = 1, else $10 = 2
# $11 != $12 -> $13 = 1, else $13 = 2
