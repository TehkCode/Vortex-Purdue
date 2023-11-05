# set the address where you want this
# code segment
org 0x0000

addi   $1, $0, 0x01
addi   $2, $0, 0x02
addi   $4, $0, 0x0050 #store to this addr

beq $1, $2, done   
sw  $2, 0($4) # Mem[0x0050] = 2
halt
    
done:
    sw $1, 0($4) # Mem[0x0050] = 1
    

    
