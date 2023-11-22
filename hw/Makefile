#
# Guillaume Hu / socet97 - hu724@purdue.edu
# 
# Makefile to simulate Vortex in Questa Sim 
# Use : Change 	
#			- TB_DIR: for VX testbench directory
#			- VX_TB: Testbench name
#           - WAVE: .do file for the tb
#
# Add new modules: 
#			- ADD_RTL: Additional design files 
#			- ADD_INCL: The file's include directory if one 
#
# Macros: 
#			- VX_SYNTHESIS
#           - FPU_FPNEW: FPNEW FPU 
#			- VX_TOP_TRACE: Creates a logfile with top level transactions
#			- SV_TRACE_EN: Allows the tracing of relevant VX signals 
#			- SV_TRACE_CORE_PIPELINE: Adds the tracing of signals inside VX's cores
#
# Run: make all or make all_gui

TB_DIR := tb
VX_TB := VX_local_mem_tb
VX_WRAPPER_TB := Vortex_wrapper_tb
VX_WRAPPER_CONDENSED_TB := Vortex_wrapper_condensed_tb
TARGET_TB := $(TB_DIR)/$(VX_TB).sv
WRAPPER_TARGET_TB := $(TB_DIR)/$(VX_WRAPPER_TB).sv
WRAPPER_CONDENSED_TARGET_TB := $(TB_DIR)/$(VX_WRAPPER_CONDENSED_TB).sv

WAVE_DIR := $(TB_DIR)/scripts
WAVE:= $(WAVE_DIR)/VX_i_d_caches.do
WRAPPER_WAVE:= $(WAVE_DIR)/VX_wrapper_waves.do
WRAPPER_CONDENSED_WAVE:= $(WAVE_DIR)/VX_wrapper_condensed_waves.do

# Additional files 
ADD_INCL += $(INCL)
ADD_RTL += tb/Vortex_mem_slave.sv tb/Vortex_mem_slave_condensed.sv tb/Vortex_wrapper_no_Vortex_condensed.sv rtl/Vortex_wrapper_condensed.sv tb/Vortex_mem_slave.vh tb/VX_ahb_adapter.sv tb/counter.sv tb/Vortex_wrapper_no_Vortex.sv rtl/Vortex_wrapper.sv

#Macros
MACROS := +define+VX_SYNTHESIS +define+FPU_FPNEW +define+VX_TOP_TRACE +define+SV_TRACE_EN +define+SV_TRACE_CORE_PIPELINE +define+SV_TRACE_CORE_DCACHE +define+SV_TRACE_CACHE_DATA +define+EXT_TEX_ENABLE

### Directories 
# Vortex
RTL_DIR := rtl
AFU_DIR := $(RTL_DIR)/afu
CACHE_DIR := $(RTL_DIR)/cache
FP_CORE_DIR := $(RTL_DIR)/fp_cores
INTERFACES_DIR := $(RTL_DIR)/interfaces
LIBS_DIR := $(RTL_DIR)/libs
TEX_UNIT_DIR := $(RTL_DIR)/tex_unit
DPI_DIR := dpi

#     FPNEW 
FPNEW_DIR := ../third_party/fpnew/src
 # COMMON CELLS 
COMMON_CELL_DIR := $(FPNEW_DIR)/common_cells/src

# AHB
AHB_DIR := $(RTL_DIR)/ahb
AHB_INTF_DIR := $(AHB_DIR)/ahb_if
AHB_INTF_FILES := $(wildcard $(AHB_INTF_DIR)/*.sv)
AHB_RTL_FILES := $(AHB_DIR)/ahb_manager/src/ahb_manager.sv

INCL := 
INCL := include

#Interface files 
INTF_FILES := 
INTF_FILES += $(wildcard $(INTERFACES_DIR)/*.sv)

#FPNEW files 
FPNEW_FILES :=
FPNEW_FILES += $(wildcard $(FPNEW_DIR)/*.sv)

FPNEW_FILES += $(wildcard $(COMMON_CELL_DIR)/*.sv)

#FPNEW PKG
FPNEW_PKG := $(FPNEW_DIR)/fpnew_pkg.sv
FPNEW_PKG += $(wildcard $(COMMON_CELL_DIR)/*_pkg.sv)

#COMMON CELLS INC 
COMMON_CELL_INC := $(FPNEW_DIR)/common_cells/include

#FPU DIV
FPU_DIV_DIR := $(FPNEW_DIR)/fpu_div_sqrt_mvp/hdl
FPU_DIV_FILES := $(wildcard $(FPU_DIV_DIR)/*.sv)
FPU_DIV_PKG := $(FPU_DIV_DIR)/defs_div_sqrt_mvp.sv

#Design files 
RTL_FILES := 
#RTL_FILES += $(wildcard $(AFU_DIR)/*.sv)
RTL_FILES += $(wildcard $(CACHE_DIR)/*.sv)
RTL_FILES += $(wildcard $(FP_CORE_DIR)/*.sv)
RTL_FILES += $(wildcard $(LIBS_DIR)/*.sv)
RTL_FILES += $(wildcard $(TEXT_UNIT_DIR)/*.sv)

RTL_FILES += $(wildcard $(RTL_DIR)/*.sv)
RTL_FILES += $(wildcard $(TEX_UNIT_DIR)/*.sv)


WORKDIR := work

# Compiler/simulator options
VSIMOPTS := -lib $(WORKDIR)
VLOGOPTS := -sv -work $(WORKDIR) -suppress 13389 -incr -vopt $(MACROS)

# Note: C-functions in SV 
#VLOGOPTS_DPI := -dpiheader dpi_header_file.h -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors" +define+UTIL_DPI +define+FLOAT_DPI

all: $(WORKDIR) compile run 

all_gui: $(WORKDIR) compile run_gui

all_debug: $(WORKDIR) compile run_debug

all_wrapper: $(WORKDIR) compile run_wrapper

all_wrapper_gui: $(WORKDIR) compile run_wrapper_gui

all_wrapper_condensed: $(WORKDIR) compile run_wrapper_condensed

all_wrapper_condensed_gui: $(WORKDIR) compile run_wrapper_condensed_gui

compile: $(WORKDIR)
		#@vlog $(VLOGOPTS) $(wildcard $(INCL)/*_pkg.sv)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(INTF_FILES) 
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(AHB_INTF_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(AHB_RTL_FILES)
		@vlog $(VLOGOPTS) $(FPNEW_PKG) $(FPU_DIV_PKG)
		@vlog $(VLOGOPTS) +incdir+$(INCL) +incdir+$(COMMON_CELL_INC) +incdir+$(COMMON_CELL_DIR) $(FPNEW_FILES)
		@vlog $(VLOGOPTS) +incdir+$(FPU_DIV_DIR) $(FPU_DIV_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) +incdir+$(FPNEW_DIR) +incdir+$(FPU_DIV_DIR) +incdir+$(DPI_DIR) $(RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(ADD_INCL) $(ADD_RTL)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(TARGET_TB)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(WRAPPER_TARGET_TB)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(WRAPPER_CONDENSED_TARGET_TB)

run:
		vsim $(VSIMOPTS) -c \
		$(VX_TB) \
		-voptargs=+acc \
		-coverage \
		-do "$(WAVE)" \
		-do "run -all" \
		-do "exit" \

run_gui: 
		vsim $(VSIMOPTS) -gui \
		$(VX_TB) \
		-voptargs=+acc \
		-coverage \
		-do "$(WAVE)" \
		-do "run -all" \

run_wrapper:
	vsim $(VSIMOPTS) -c \
	$(VX_WRAPPER_TB) \
	-voptargs=+acc \
	-coverage \
	-do "$(WRAPPER_WAVE)" \
	-do "run -all" \
	-do "exit" \

run_wrapper_gui:
	vsim $(VSIMOPTS) -gui \
	$(VX_WRAPPER_TB) \
	-voptargs=+acc \
	-coverage \
	-do "$(WRAPPER_WAVE)" \
	-do "run -all" \

run_wrapper_condensed:
	vsim $(VSIMOPTS) -c \
	$(VX_WRAPPER_CONDENSED_TB) \
	-voptargs=+acc \
	-coverage \
	-do "$(WRAPPER_CONDENSED_WAVE)" \
	-do "run -all" \
	-do "exit" \

run_wrapper_condensed_gui:
	vsim $(VSIMOPTS) -gui \
	$(VX_WRAPPER_CONDENSED_TB) \
	-voptargs=+acc \
	-coverage \
	-do "$(WRAPPER_CONDENSED_WAVE)" \
	-do "run -all" \

$(WORKDIR):
	@vlib $(WORKDIR)

clean: 
	rm -rf work $(WORKDIR) transcript *.vstf 
	rm *.wlf
	rm VX_top_trace.txt
	rm VX_logfile.txt

# RTL_DIR=./rtl
# SCRIPT_DIR=./scripts

# all: VX_config.h

# VX_config.h: $(RTL_DIR)/VX_config.vh	 
# 	$(SCRIPT_DIR)/gen_config.py -i $(RTL_DIR)/VX_config.vh -o VX_config.h

# clean:
# 	rm -f VX_config.h

# .PHONY: VX_config.h
