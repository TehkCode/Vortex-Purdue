import drawio_generate 
import extract_mod 
from os import *

#To generate page for one module
INPUT_FILE  = "VX_commit.sv"
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

def main():
  generate_for_many_module()  

if __name__ == "__main__":
  main()
