# set the address where you want this
# code segment
org 0x0000

addi   $t4, $0, 0x80 
addi   $t0, $0, 0x01
addi   $t2, $0, 0xff  
addi   $t1, $0, done
jr $t1
sw $t2, 0($t4) # Mem[0x08] = ff

done:
    sw $t0, 0($t4) # Mem[0x08] = 1
    halt
