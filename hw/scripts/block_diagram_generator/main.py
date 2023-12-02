import drawio_generate 
import extract_mod 
from os import path, listdir

#To generate page for one module
INPUT_FILE  = "/home/asicfab/a/socet152/Vortex-Purdue/hw/rtl/VX_ibuffer.sv"
#To generate pages in single file by walking in directory
INPUT_WALK_PATH = "/home/asicfab/a/socet152/Vortex-Purdue/hw/rtl/"

OUTPUT_FILE = "//home/asicfab/a/socet152/Vortex-Purdue/hw/rtl/diagrams/rtl_top.drawio"
INTERFACE_PATH = "/home/asicfab/a/socet152/Vortex-Purdue/hw/rtl/interfaces"

def generate_for_one_module():
  (module_name, input_signals,output_signals) = extract_mod.extract_module_signals(INPUT_FILE, INTERFACE_PATH)

  print(module_name) 
  print("Input Signals:")
  for signal in input_signals:
    print(signal)

  print("\nOutput Signals:")
  for signal in output_signals:
    print(signal)

  drawio_generate.generate_page(module_name, input_signals,output_signals, OUTPUT_FILE)

def generate_for_many_module():
  modules_dict = {}
  # Get a list of all files in the current working directory
  files = listdir(INPUT_WALK_PATH)
  # Get a list of all .sv files
  sv_files = [file for file in files if file.endswith(".sv")]

  for file in sv_files:
    (module_name, input_signals,output_signals) = extract_mod.extract_module_signals(INPUT_WALK_PATH+file, INTERFACE_PATH)
    modules_dict[module_name] = (input_signals,output_signals)
  
  drawio_generate.generate_pages(modules_dict, OUTPUT_FILE)

def main():
  generate_for_one_module()
  # generate_for_many_module()  

if __name__ == "__main__":
  main()
