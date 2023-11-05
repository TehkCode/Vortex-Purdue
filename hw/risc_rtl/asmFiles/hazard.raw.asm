org 0x0000

ori $20, $0, 0x0090   # Store address of the results
ori $8, $0, 0x00FF
ori $9, $0, 0xFF00
add $15, $8, $9
and $16, $15, $9
or $16, $16, $15
add $17, $16, $15
sw $15, 0($20) 
sw $16, 4($20)
sw $17, 8($20)
# Expectation $15 = 0xFFFF, $16 = 0xFFFF, $17 = 0x1FFFE
halt
