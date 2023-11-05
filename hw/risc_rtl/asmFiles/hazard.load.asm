org 0x0000
ori $21, $0, 0x0090 # Store address of the results
ori $5, $0, 0x0006  # Initialization of $5
ori $2, $0, 0x0050  # Store address of the loaded variable
ori $20, $0, 0x0005 # Store value of the loaded variable
sw $20, 20($2)    # No NOPs as the hardware should be invariant to RAM latency
lw $3, 20($2)
and $4, $3, $5
or $4, $4, $3
add $9, $4, $3
sw $3, 0($21)
sw $4, 4($21)
sw $9, 8($21)
halt
# Expected results: $3 = 5, $4 = 4 -> 5, $9 = 0x000A
