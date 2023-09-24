import drawio_generate 
import extract_mod 
from os import *

#To generate page for one module
INPUT_FILE  = "VX_alu_unit.sv"
#To generate pages in single file by walking in directory
INPUT_WALK_PATH = "/"

OUTPUT_FILE = "diagrams/"
INTERFACE_PATH = "interfaces/"

def generate_for_one_module(inputfile):
  (module_name, input_signals,output_signals) = extract_mod.extract_module_signals(INPUT_FILE, INTERFACE_PATH)

  print(module_name) 
  print("Input Signals:")
  for signal in input_signals:
    print(signal)

  print("\nOutput Signals:")
  for signal in output_signals:
    print(signal)

  drawio_generate.generate_page(module_name, input_signals,output_signals, module_name+".drawio.xml")

def generate_for_many_module():
  modules_dict = {}
  # Get a list of all files in the current working directory
  files = listdir()
  print("Here: ")
  # Get a list of all .sv files
  sv_files = [file for file in files if file.endswith(".sv")]
  output_files = [OUTPUT_FILE + file[0:file.find('.sv')] + ".drawio.xml" for file in files if file.endswith(".sv")]
  print(sv_files)
  print (output_files)

  for file in sv_files:
    print(file)
    (module_name, input_signals,output_signals) = extract_mod.extract_module_signals(file, INTERFACE_PATH)
    print(module_name + "\n")
    drawio_generate.generate_page(module_name, input_signals,output_signals, OUTPUT_FILE+module_name+".drawio.xml")
    input_signals.clear()
    output_signals.clear()

def generate_modules_pages_sheet():
  modules_dict = {}
  # Get a list of all files in the current working directory
  files = listdir(INPUT_WALK_PATH)
  # Get a list of all .sv files
  sv_files = [file for file in files if file.endswith(".sv")]

  for file in sv_files:
    (module_name, input_signals,output_signals) = extract_mod.extract_module_signals(INPUT_WALK_PATH+file, INTERFACE_PATH)
    modules_dict[module_name] = (input_signals,output_signals)
  
  drawio_generate.generate_pages(modules_dict, OUTPUT_FILE)

top_lvl_list = [ \
"VX_alu_unit.sv ", \
"VX_cache_arb.sv ", \
"VX_cluster.sv ", \
"VX_commit.sv ", \
"VX_config.vh ", \
"VX_core.sv ", \
"VX_csr_data.sv ", \
"VX_csr_unit.sv ", \
"VX_decode.sv ", \
"VX_define.vh ", \
"VX_dispatch.sv ", \
"VX_execute.sv ", \
"VX_fetch.sv ", \
"VX_fpu_unit.sv ", \
"VX_gpr_stage.sv ", \
"VX_gpu_types.vh ", \
"VX_gpu_unit.sv ", \
"VX_ibuffer.sv ", \
"VX_icache_stage.sv ", \
"VX_ipdom_stack.sv ", \
"VX_issue.sv ", \
"VX_lsu_unit.sv ", \
"VX_mem_arb.sv ", \
"VX_mem_unit.sv ", \
"VX_muldiv.sv ", \
"VX_pipeline.sv ", \
"VX_platform.vh ", \
"VX_scope.vh ", \
"VX_scoreboard.sv ", \
"VX_smem_arb.sv ", \
"VX_trace_instr.vh ", \
"VX_warp_sched.sv ", \
"VX_writeback.sv ", \
"Vortex.sv ", \
"Vortex_axi.sv " ]

def main():
  
  for file in top_lvl_list:
    print(file)
    (module_name, input_signals,output_signals) = extract_mod.extract_module_signals(file, INTERFACE_PATH)
    print(module_name + "\n")
    drawio_generate.generate_page(module_name, input_signals,output_signals, OUTPUT_FILE+module_name+".drawio.xml")
    input_signals.clear()
    output_signals.clear()

  # generate_for_many_module()  

if __name__ == "__main__":
  main()

