# Loading Vortex_mem_slave.sv with corresponding hex file data

### load_Vortex_mem_slave.py
script to create Vortex_mem_slave.sv source file for given .hex file which interfaces directly with Vortex memory interfacing signals and AHB slave interfacing signals

- commandline (from inside /tb directory):  
``python3 load_Vortex_mem_slave.py <.hex file name> <optional flags>``  
  - <.hex file name> is relative path from /tb (if in hex_files folder, need to do ``hex_files/<.hex file name>``)

- flags:  
  - ``-zero``: reset all registers to 0 instead of corresponding hex file values
  - ``-p``: print debugging info
  - ``-size <n bits to represent size, 2^n>``: change the size of the local mem
  
- shortcut with Makefile (limited functionality, uses default size of 14-bit address space)  
``make <.hex file name>.load``
  - <.hex file name> must be located in hex_files folder. don't include ``hex_files/``

# Simulating Vortex_mem_slave_tb.sv
- testbench expects loaded hex file to be rv32ud-p-fadd.hex  
  ``make rv32ud-p-fadd.hex.load``  

- commandline (from inside /tb directory):
  - sim without waves  
  ``make Vortex_mem_slave.sim``
  - sim with waves  
  ``make Vortex_mem_slave.wav``
