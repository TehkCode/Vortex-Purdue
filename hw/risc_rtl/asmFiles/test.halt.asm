# set the address where you want this
# code segment
org 0x0000

addi   $1, $0, 0xF0
addi   $2, $0, 0x80 

lw    $3,0($1)        #$3 <= Mem[0x0F0]
lw    $4,4($1) 

sw $3,0($2)
sw $4,4($2)

halt   

sw $3,0($2)
sw $4,4($2)
sw $3,8($2)
sw $4,12($2)
sw $3,16($2)
sw $4,20($2)
sw $3,24($2)
sw $4,28($2)



org   0x00F0
cfw   0x7337
cfw   0x2701
