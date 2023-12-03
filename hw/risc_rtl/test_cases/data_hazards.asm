addi x2, x0, 0x00F0    
addi x3, x0, 0x0FF0     
addi x5, x0, 0x0080    
add x1, x2, x3         
sub x4, x1, x5         
sw x4, 0(x1)           
sw x1, 0(x2)
sw x5, 0(x4)           