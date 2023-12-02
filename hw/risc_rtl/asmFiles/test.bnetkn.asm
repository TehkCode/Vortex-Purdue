# set the address where you want this
# code segment
org 0x0000


addi   $t0, $0, 0x01 
addi   $t1, $0, 0x02 

bne $t0, $t1, done
   
addi  $t3, $0, 0xff
sw $t3, 0($t4) # Mem[0x08] = ff
    
done:    
    sw $t1, 0($t4) # Mem[0x08] = 1
    halt
