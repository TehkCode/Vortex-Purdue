# Simulating VX on Questa

First, make sure that all submodules are available. If not, run from main directory: 
```
git submodule update --init --recursive

```

Then go back to /hw directory and make changes to the Makefile if needed. The current macros for successful simulation are:  

* SYNTHESIS: Uses synthesizable constructs 
* FPU_FPNEW: Uses the FPNEW Floating-Point Unit

Optional macros: 

* VX_TOP_TRACE: Top-level VX memory transaction trace to a logfile


Vortex with Vortex_mem_slave: 
```
make all or make all_gui
```
Vortex with Vortex_wrapper_no_Vortex: 
```
make all_wrapper or make all_wrapper_gui
```

# Run Regression on Vortex Unit Test Hex Files

```
bash testhex
```
Verbose output from hex file runs can be found in testhex_output.log
  
# Using Trace File Scraper

Generate trace file from gold model C++ simulation by running rtlsim on local machine or virtual machine. See Vortex Software:  
https://wiki.itap.purdue.edu/display/ecedesign/Vortex+Software

Generate trace file from questa version by running:
```
make all
```
The generated questa trace file is then "VX_top_trace.txt".  

Use trace file scraper to compare rtlsim file and questa file:
```
python3 scrape_traces.py <rtlsim trace file> <questa trace file> <optional flags>
```
- flags:  
  - ``-p``: print debugging info

This script gives info about the difference between the two traces and generates simplified trace files which you can visually compare with tkdiff:
```
tkdiff <rtlsim trace file>.scrape.log <questa trace file>.scrape.log
```
