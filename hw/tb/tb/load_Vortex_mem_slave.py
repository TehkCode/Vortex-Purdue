"""
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    script to create Vortex_mem_slave.sv source for given .hex file which interfaces with AFTx07 core
    with AHB generic bus interface and Vortex with memory interface

    usage:
        commandline:
            python3 load_Vortex_mem_slave.py <.hex file name> <flags>

        flags:
            -p = print debugging info
            -zero = reset value all 0's
            -size = 2^size register array

    general script flow:
        - parse intelhex file, putting either designated hex file value or 0 into reg file for each byte
"""

###########################################################################################################
# imports
import sys

###########################################################################################################
# consts:

# 16 KB = 16384 B --> log2(16384) = 14 bit addr space
LOCAL_MEM_NUM_BITS = 15
LOCAL_MEM_SIZE = 2**LOCAL_MEM_NUM_BITS

VX_MEM_BYTEEN_WIDTH = 64
VX_MEM_ADDR_WIDTH = 26
VX_MEM_DATA_WIDTH = 512
VX_MEM_TAG_WIDTH = 56       # 55 for ENABLE_SM = 0

DO_PRINTS = False
LOAD_ZEROS = False

###########################################################################################################
# classes:


###########################################################################################################
# funcs:

def hex_str_to_int(hex_str):
    """
    function for converting hex string to int value

    parameters: 
        hex_str: string of hex digits (no 0x)

    output:
        int value of hex string
    """
    return int(hex_str, base=16)


def bits_needed(n):
    """
    function calculating the number of bits needed to represent n different things

    parameters:
        n: number of things to represent

    output:
        number of bits needed to represent n things
    """
    return (n - 1).bit_length()


# parse source shell file lines and intel hex file lines to construct .sv source file
def construct_Vortex_mem_slave_sv(Vortex_mem_slave_shell_lines, intelhex_lines, intelhex_name):
    """
    function to parse out intel hex file lines to construct reg file instantiation of .sv and complete 
    Vortex_mem_slave.sv with Vortex_mem_slave_shell.txt

    parameters:
        Vortex_mem_slave_shell_lines: lines in Vortex_mem_slave_shell.txt file wrapping around reg file reset
            values    
        intelhex_lines: lines in intel hex file which will reg file reset values
        intelhex_name: name of intel hex file
    
    outputs:
        Vortex_mem_slave_sv_lines: lines which make up source file Vortex_mem_slave.sv
    """

    ###########################
    # display .hex file name: #
    ###########################

    hex_file_name_lines = [
        f"/////////////" + "/" * (len(intelhex_name)+2) + f"///\n"
        f"// LOADED IN \"{intelhex_name}\" //\n"
        f"/////////////" + "/" * (len(intelhex_name)+2) + f"///\n"
    ]

    ##########################
    # modify local mem size: #
    ##########################

    # set LOCAL_MEM_SIZE parameter line
    local_mem_size_lines = [
        f"\tparameter LOCAL_MEM_SIZE = {LOCAL_MEM_NUM_BITS}\n"
    ]

    ###########################
    # make reg file instance: #
    ###########################
    
    # start lines of reg file instance
    reg_file_instance_lines = []

    # check for LOAD_ZEROS
    if (LOAD_ZEROS):
        reg_file_instance_lines += [
            f"\t\t\t// LOAD_ZEROS",
            f"\t\t\treg_file <= '0;",
        ]

    # otherwise, follow hex file
    else:
        # iterate through intel hex str lines, checking for different record types, making reg file reset values
        line_num = 0
        last_byte_num = 0
        byte_num = 0
        for line in intelhex_lines:
            line_num += 1

            # check for eof
            if (line[7:8 +1] == "01"):
                if (DO_PRINTS):
                    print("intelhex: eof\n")
                break

            # check for PC start line
            elif (line[7:8 +1] == "05"):
                if (DO_PRINTS):
                    print(f"intelhex: PC should start at 0x{line[9:16 +1]}")
            
            # check for extended addr line
            elif (line[7:8 +1] == "04"):

                # prep for new chunk
                if (DO_PRINTS):
                    print(f"intelhex: upper address bits 0x{line[9:12 +1]}")

                # reset byte_num
                byte_num = 0

            # check for data line
            elif (line[7:8 +1] == "00"):

                # get next byte_num
                byte_num = hex_str_to_int(line[3:6 +1])

                # check for bytes to fill in after to get to current line
                if (last_byte_num > byte_num):
                    print("ERROR: last_byte_num > byte_num")
                    quit()
                while (last_byte_num < byte_num):
                    reg_file_instance_lines += [
                        f"\t\t\treg_file[{last_byte_num}] <= 8'h00;",
                    ]
                    last_byte_num += 1

                # iterate through data words
                for word_index in range(hex_str_to_int(line[1:2 +1]) // 4):
                    # get next word (8-char string) from data section
                    next_word = line[9 + 8*word_index:9 + 8*(word_index + 1)]
                    reg_file_instance_lines += [
                        f"\t\t\treg_file[{last_byte_num}] <= 8'h{next_word[0:2]};",
                        f"\t\t\treg_file[{last_byte_num + 1}] <= 8'h{next_word[2:4]};",
                        f"\t\t\treg_file[{last_byte_num + 2}] <= 8'h{next_word[4:6]};",
                        f"\t\t\treg_file[{last_byte_num + 3}] <= 8'h{next_word[6:8]};",
                    ]
                    last_byte_num += 4

            # otherwise, can't parse this
            else:
                print(f"ERROR: don't know how to parse line {line_num} of intel hex")
                quit()

        # check for too many bytes
        if (last_byte_num > LOCAL_MEM_SIZE):
            print(f"ERROR: too many bytes to fit in {LOCAL_MEM_SIZE} byte reg file")
            quit()

        # check for any bytes to fill in after lines
        while (last_byte_num < LOCAL_MEM_SIZE):
            reg_file_instance_lines += [
                f"\t\t\treg_file[{last_byte_num}] <= 8'h00;",
            ]
            last_byte_num += 1

    # add newlines to end of each line and replace \t tabs with 4 spaces
    reg_file_instance_lines = [line.replace("\t", "    ") + "\n" for line in reg_file_instance_lines]

    #########################################
    # make Vortex mem interface read logic: #
    #########################################

    # start lines
    Vortex_read_logic_lines = []

    # iterate through 512 bits = 64 bytes of data 
    for i in range(64):
        Vortex_read_logic_lines.append(
            f"\t\tnext_mem_rsp_data[{8*i+7}:{8*i}] = reg_file[{{mem_req_addr[7:0], 6'd{i}}}];"
        )

    # add newlines to end of each line and replace \t tabs with 4 spaces
    Vortex_read_logic_lines = [line.replace("\t", "    ") + "\n" for line in Vortex_read_logic_lines]

    ##########################################
    # make Vortex mem interface write logic: #
    ##########################################

    # start lines
    Vortex_write_logic_lines = []

    # iterate through 512 bits = 64 bytes of data
    for i in range(64):
        Vortex_write_logic_lines.append(
            f"\t\t\tif (mem_req_byteen[{i}]) next_reg_file[{{mem_req_addr[7:0], 6'd{i}}}] = "
            + f"mem_req_data[{8*i+7}:{8*i}];"
        )

    # add newlines to end of each line and replace \t tabs with 4 spaces
    Vortex_write_logic_lines = [line.replace("\t", "    ") + "\n" for line in Vortex_write_logic_lines]

    ##########################
    # compile lines of file: #
    ##########################

    # get indices in shell file
    try:
        hex_file_name_index = Vortex_mem_slave_shell_lines.index("< program .hex file name here >\n")
        local_mem_size_index = Vortex_mem_slave_shell_lines.index("< LOCAL_MEM_SIZE val here >\n")
        reg_file_instance_index = Vortex_mem_slave_shell_lines.index("< reset vals here >\n")
        Vortex_read_logic_index = Vortex_mem_slave_shell_lines.index("< Vortex read logic here >\n")
        Vortex_write_logic_index = Vortex_mem_slave_shell_lines.index("< Vortex write logic here >\n")

    except:
        print("ERROR: couldn't find placeholder line(s) in shell text file")
        quit()

    # add up shell pieces and instance piece
    reg_file_sv_lines = Vortex_mem_slave_shell_lines[:hex_file_name_index]
    reg_file_sv_lines += hex_file_name_lines
    reg_file_sv_lines += Vortex_mem_slave_shell_lines[hex_file_name_index + 1:local_mem_size_index]
    reg_file_sv_lines += local_mem_size_lines
    reg_file_sv_lines += Vortex_mem_slave_shell_lines[local_mem_size_index + 1:reg_file_instance_index]
    reg_file_sv_lines += reg_file_instance_lines
    reg_file_sv_lines += Vortex_mem_slave_shell_lines[reg_file_instance_index + 1:Vortex_read_logic_index]
    reg_file_sv_lines += Vortex_read_logic_lines
    reg_file_sv_lines += Vortex_mem_slave_shell_lines[Vortex_read_logic_index + 1:Vortex_write_logic_index]
    reg_file_sv_lines += Vortex_write_logic_lines
    reg_file_sv_lines += Vortex_mem_slave_shell_lines[Vortex_write_logic_index + 1:]

    # return completed lines of file
    return reg_file_sv_lines


# overall function to take in hex file and output corresponding register file 
def intelhex_to_Vortex_mem_slave_sv(hex_file_name, Vortex_mem_slave_sv_name):
    """
    function to take in intelhex file and make ram faking register file top module, utilizing
    local_mem_shell.txt

    parameters:
        hex_file_name: name of intelhex .hex file to be used as memory space for ram fake 
        Vortex_mem_slave_sv_name: name of SystemVerilog .sv source file to be output defining top ram fake module

    outputs:
        none
    """

    # try to get source shell
    try:
        Vortex_mem_slave_shell_fp = open("Vortex_mem_slave_shell.txt", "r")
        Vortex_mem_slave_shell_lines = Vortex_mem_slave_shell_fp.readlines()
        Vortex_mem_slave_shell_fp.close()

    except:
        print("ERROR: need Vortex_mem_slave_shell.txt")
        quit()

    # try to get .hex file
    if (not LOAD_ZEROS):
        try:
            # get .hex lines
            intelhex_fp = open(hex_file_name, "r")
            intelhex_lines = intelhex_fp.readlines()
            intelhex_lines = [line.strip() for line in intelhex_lines]
            intelhex_fp.close()

        except:
            print("ERROR: couldn't find .hex file")
            quit()

    # construct source .sv lines for reg file:

    # check for LOAD_ZEROS
    if (LOAD_ZEROS):
        Vortex_mem_slave_sv_lines = construct_Vortex_mem_slave_sv(Vortex_mem_slave_shell_lines, False, hex_file_name)
    # otherwise, use hex file
    else:
        Vortex_mem_slave_sv_lines = construct_Vortex_mem_slave_sv(Vortex_mem_slave_shell_lines, intelhex_lines, hex_file_name)

    # try to write source .sv file
    try:
        # get .hex lines
        local_mem_sv_fp = open(Vortex_mem_slave_sv_name, "w")
        local_mem_sv_fp.writelines(Vortex_mem_slave_sv_lines)
        local_mem_sv_fp.close()

        print("SUCCESS: Vortex_mem_slave.sv loaded")

    except:
        print("ERROR: couldn't write .sv file")
        quit()


###########################################################################################################
# main:

if __name__ == "__main__":

    # check for 1 commandline argument with python load_local_mem.py
    if (len(sys.argv) < 2):
        print("ERROR: need to follow required commandline format:")
        print("python3 load_Vortex_mem_slave.py <.hex file name>  <flags>")
        quit()

    if ("-p" in sys.argv):
        DO_PRINTS = True

    if ("-size" in sys.argv):
        size_index = sys.argv.index("-size") + 1
        LOCAL_MEM_NUM_BITS = int(sys.argv[size_index])
        LOCAL_MEM_SIZE = 2**LOCAL_MEM_NUM_BITS

    if ("-zero" in sys.argv):
        LOAD_ZEROS = True

    elif (not sys.argv[1].endswith(".hex")):
        print("ERROR: input must be intel hex file")
        quit()

    if DO_PRINTS:
        print(f"DO_PRINTS = {DO_PRINTS}")
        print(f"LOAD_ZEROS = {LOAD_ZEROS}")
        print(f"LOCAL_MEM_NUM_BITS = {LOCAL_MEM_NUM_BITS}")

    # run .sv source builder
    intelhex_to_Vortex_mem_slave_sv(sys.argv[1], "Vortex_mem_slave.sv")
