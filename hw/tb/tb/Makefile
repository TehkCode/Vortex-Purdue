# LOCAL_MEM
LOCAL_MEM_DEF := local_mem.vh
LOCAL_MEM_RTL_FILES := local_mem.sv 
LOCAL_MEM_TB := local_mem_tb.sv

# VORTEX_MEM_SLAVE
VORTEX_MEM_SLAVE_DEF := Vortex_mem_slave.vh
VORTEX_MEM_SLAVE_RTL_FILES := Vortex_mem_slave.sv 
VORTEX_MEM_SLAVE_TB := Vortex_mem_slave_tb.sv

# VORTEX_MEM_SLAVE_CONDENSED
VORTEX_MEM_SLAVE_CONDENSED_DEF := Vortex_mem_slave.vh
VORTEX_MEM_SLAVE_CONDENSED_RTL_FILES := Vortex_mem_slave_condensed.sv 
VORTEX_MEM_SLAVE_CONDENSED_TB := Vortex_mem_slave_condensed_tb.sv

# VX_AHB_ADAPTER
VX_AHB_ADAPTER_DEF := ../include/VX_ahb_adapter.vh
VX_AHB_ADAPTER_RTL_FILES := VX_ahb_adapter.sv counter.sv
VX_AHB_ADAPTER_TB := VX_ahb_adapter_tb.sv

# VORTEX_WRAPPER_NO_VORTEX
VORTEX_WRAPPER_NO_VORTEX_DEF := 
VORTEX_WRAPPER_NO_VORTEX_RTL_FILES := Vortex_wrapper_no_Vortex.sv
VORTEX_WRAPPER_NO_VORTEX_TB := Vortex_wrapper_no_Vortex_tb.sv

# VORTEX_WRAPPER_NO_VORTEX_CONDENSED
VORTEX_WRAPPER_NO_VORTEX_CONDENSED_DEF := 
VORTEX_WRAPPER_NO_VORTEX_CONDENSED_RTL_FILES := Vortex_wrapper_no_Vortex_condensed.sv
VORTEX_WRAPPER_NO_VORTEX_CONDENSED_TB := Vortex_wrapper_no_Vortex_condensed_tb.sv

# DIR's
INCL := ../include
WORKDIR := work
SCRDIR := scripts

# others hard defined
SIMTIME := -all

# view waveform in graphical mode and load do file if there is one
LOCAL_MEM_DOFILE 		= local_mem
LOCAL_MEM_WAVDO			= do $(SCRDIR)/$(LOCAL_MEM_DOFILE).do
LOCAL_MEM_SIMDO			= "view objects; $(LOCAL_MEM_WAVDO); run $(SIMTIME);" -onfinish stop

VORTEX_MEM_SLAVE_DOFILE	= Vortex_mem_slave
VORTEX_MEM_SLAVE_WAVDO	= do $(SCRDIR)/$(VORTEX_MEM_SLAVE_DOFILE).do
VORTEX_MEM_SLAVE_SIMDO	= "view objects; $(VORTEX_MEM_SLAVE_WAVDO); run $(SIMTIME);" -onfinish stop

VORTEX_MEM_SLAVE_CONDENSED_DOFILE	= Vortex_mem_slave_condensed
VORTEX_MEM_SLAVE_CONDENSED_WAVDO	= do $(SCRDIR)/$(VORTEX_MEM_SLAVE_CONDENSED_DOFILE).do
VORTEX_MEM_SLAVE_CONDENSED_SIMDO	= "view objects; $(VORTEX_MEM_SLAVE_CONDENSED_WAVDO); run $(SIMTIME);" -onfinish stop

VX_AHB_ADAPTER_DOFILE	= VX_ahb_adapter
VX_AHB_ADAPTER_WAVDO	= do $(SCRDIR)/$(VX_AHB_ADAPTER_DOFILE).do
VX_AHB_ADAPTER_SIMDO	= "view objects; $(VX_AHB_ADAPTER_WAVDO); run $(SIMTIME);" -onfinish stop

VORTEX_WRAPPER_NO_VORTEX_DOFILE	= Vortex_wrapper_no_Vortex
VORTEX_WRAPPER_NO_VORTEX_WAVDO	= do $(SCRDIR)/$(VORTEX_WRAPPER_NO_VORTEX_DOFILE).do
VORTEX_WRAPPER_NO_VORTEX_SIMDO	= "view objects; $(VORTEX_WRAPPER_NO_VORTEX_WAVDO); run $(SIMTIME);" -onfinish stop

VORTEX_WRAPPER_NO_VORTEX_CONDENSED_DOFILE	= Vortex_wrapper_no_Vortex_condensed
VORTEX_WRAPPER_NO_VORTEX_CONDENSED_WAVDO	= do $(SCRDIR)/$(VORTEX_WRAPPER_NO_VORTEX_CONDENSED_DOFILE).do
VORTEX_WRAPPER_NO_VORTEX_CONDENSED_SIMDO	= "view objects; $(VORTEX_WRAPPER_NO_VORTEX_CONDENSED_WAVDO); run $(SIMTIME);" -onfinish stop

# SIM_UI_OPT := -gui
# SIM_UI_OPT := -c

# Compiler/simulator options
VSIMOPTS := -lib $(WORKDIR)
VLOGOPTS := -sv -work $(WORKDIR) -incr -vopt +define+SYNTHESIS #+define+SYNTHESIS
# VLOGOPTS_DPI := -sv -work $(WORKDIR) -dpiheader dpi_header_file.h -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors" +define+UTIL_DPI +define+FLOAT_DPI
# VLOGOPTS_DPI_CPP := -work $(WORKDIR) -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors"

# TARGETS:
zero.load: load_Vortex_mem_slave.py
		python3 load_Vortex_mem_slave.py -zero -size 15

%.load: load_Vortex_mem_slave.py
		python3 load_Vortex_mem_slave.py hex_files/$*

%.vec.load: load_Vortex_mem_slave.py
		python3 load_Vortex_mem_slave.py hex_files_vec/$* -size 18

compile_local_mem: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_TB)

local_mem.wav: compile_local_mem
		vsim $(VSIMOPTS) -gui \
		local_mem_tb \
		-coverage -voptargs=+acc \
		-do $(LOCAL_MEM_SIMDO)

local_mem.sim: compile_local_mem
		vsim $(VSIMOPTS) -c \
		local_mem_tb \
		-coverage \
		-do "run $(SIMTIME);"

compile_Vortex_mem_slave: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_TB)

Vortex_mem_slave.wav: compile_Vortex_mem_slave
		vsim $(VSIMOPTS) -gui \
		Vortex_mem_slave_tb \
		-coverage -voptargs=+acc \
		-do $(VORTEX_MEM_SLAVE_SIMDO)

Vortex_mem_slave.sim: compile_Vortex_mem_slave
		vsim $(VSIMOPTS) -c \
		Vortex_mem_slave_tb \
		-coverage \
		-do "run $(SIMTIME);"

compile_Vortex_mem_slave_condensed: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_CONDENSED_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_CONDENSED_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_CONDENSED_TB)

Vortex_mem_slave_condensed.wav: compile_Vortex_mem_slave_condensed
		vsim $(VSIMOPTS) -gui \
		Vortex_mem_slave_condensed_tb \
		-coverage -voptargs=+acc \
		-do $(VORTEX_MEM_SLAVE_CONDENSED_SIMDO)

Vortex_mem_slave_condensed.sim: compile_Vortex_mem_slave_condensed
		vsim $(VSIMOPTS) -c \
		Vortex_mem_slave_condensed_tb \
		-coverage \
		-do "run $(SIMTIME);"

compile_Vortex_wrapper_no_Vortex: $(WORKDIR) compile_Vortex_mem_slave compile_VX_ahb_adapter
#		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_WRAPPER_NO_VORTEX_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_WRAPPER_NO_VORTEX_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_WRAPPER_NO_VORTEX_TB)

Vortex_wrapper_no_Vortex.wav: compile_Vortex_wrapper_no_Vortex
		vsim $(VSIMOPTS) -gui \
		Vortex_wrapper_no_Vortex_tb \
		-coverage -voptargs=+acc \
		-do $(VORTEX_WRAPPER_NO_VORTEX_SIMDO)

Vortex_wrapper_no_Vortex.sim: compile_Vortex_wrapper_no_Vortex
		vsim $(VSIMOPTS) -c \
		Vortex_wrapper_no_Vortex_tb \
		-coverage \
		-do "run $(SIMTIME);"

compile_Vortex_wrapper_no_Vortex_condensed: $(WORKDIR) compile_Vortex_mem_slave_condensed compile_VX_ahb_adapter
#		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_WRAPPER_NO_VORTEX_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_WRAPPER_NO_VORTEX_CONDENSED_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_WRAPPER_NO_VORTEX_CONDENSED_TB)

Vortex_wrapper_no_Vortex_condensed.wav: compile_Vortex_wrapper_no_Vortex_condensed
		vsim $(VSIMOPTS) -gui \
		Vortex_wrapper_no_Vortex_condensed_tb \
		-coverage -voptargs=+acc \
		-do $(VORTEX_WRAPPER_NO_VORTEX_CONDENSED_SIMDO)

Vortex_wrapper_no_Vortex_condensed.sim: compile_Vortex_wrapper_no_Vortex_condensed
		vsim $(VSIMOPTS) -c \
		Vortex_wrapper_no_Vortex_condensed_tb \
		-coverage \
		-do "run $(SIMTIME);"s

compile_VX_ahb_adapter: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VX_AHB_ADAPTER_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VX_AHB_ADAPTER_RTL_FILES)
#		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VX_AHB_ADAPTER_TB)

VX_ahb_adapter.wav: compile_VX_ahb_adapter
		vsim $(VSIMOPTS) -gui \
		VX_ahb_adapter_tb \
		-coverage -voptargs=+acc \
		-do $(VX_AHB_ADAPTER_SIMDO)

VX_ahb_adapter.sim: compile_VX_ahb_adapter
		vsim $(VSIMOPTS) -c \
		VX_ahb_adapter_tb \
		-coverage \
		-do "run $(SIMTIME);"

$(WORKDIR):
	@vlib $(WORKDIR)

clean: 
	rm -rf work $(WORKDIR) transcript *.vstf 
	rm *.wlf


# RTL_DIR=./rtl
# SCRIPT_DIR=./scripts

# all: VX_config.h

# VX_config.h: $(RTL_DIR)/VX_config.vh	 
# 	$(SCRIPT_DIR)/gen_config.py -i $(RTL_DIR)/VX_config.vh -o VX_config.h

# clean:
# 	rm -f VX_config.h

# .PHONY: VX_config.h
