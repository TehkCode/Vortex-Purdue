"""
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    script to scrape through rtlsim trace log of Vortex and questa trace log of Vortex for given hex file 
    and compare memory requests

    usage:
        commandline:
            python3 scrape_traces.py <rtlsim trace file> <questa trace file> <flags>

        flags:
            -p = print debugging info
            -out <output file name> = override output file name (and directory)

    general script flow:
        - parse rtlsim trace file for memory requests
        - parse questa trace file for memory requests
        - compare the memory requests
        - write findings to output file
"""

###########################################################################################################
# imports
import sys

###########################################################################################################
# consts:

DO_PRINTS = False

###########################################################################################################
# classes:

# class for simulating effective state of memory
class MEM_Tracker():
    # instance vars:
    #   mem_state
    # methods:
    #   __init__()
    #   write()

    # init
    def __init__(self):
        self.mem_state = dict()

    # perform writes using list of Mem_Wr_Req objects
    def simulate_writes(self, write_object_list):

        # iterate through writes
        for write_object in write_object_list:
            self.write(write_object)

    # perform write using MEM_Wr_Req object
    def write(self, write_object):

        # print(f"addr = {write_object.addr}")
        # print(f"data = {write_object.data}")
        # print(f"byteen = {write_object.byteen}")

        # retrieve effective individual bytes writing to
        addr_int = int(write_object.addr, 16)
        data_str = write_object.data
        byteen_int = int(write_object.byteen, 16)
        for byte_int in list(range(64)):

            # print(f"byteen_int = {byteen_int:x}")
            # print(f"byte_int = {byte_int:x}")
            # print(f"byteen_int >> byte_int  = {byteen_int >> byte_int:x}")

            # if byte enabled, track value
            if ((byteen_int >> byte_int) % 2 == 1):

                # get address of byte
                byte_addr_int = addr_int + byte_int

                # data string is indexed backward, each character is 1/2 byte
                byte_str = data_str[64*2 - 2*byte_int - 2 : 64*2 - 2*byte_int]
                # print(byte_str)
                
                assert 'x' not in byte_str, "'x' should never be written"

                # track byte in mem
                self.mem_state[byte_addr_int] = byte_str
        
        if (DO_PRINTS):
            print(self.mem_state)

# ~struct for mem transactions (UNUSED RIGHT NOW)
class MEM_Trans():

    # instance vars:
    #   string
    # methods:
    #   __init__()
    #   get_attributes()
    
    # init
    def __init__(self, string):
        self.string = string
        self.get_attributes()

    # get attributes based on string
    def get_attributes(self):
        pass

# ~struct for mem read requests
class MEM_Rd_Req():

    # instance vars:
    #   type
    #   addr
    #   tag
    #   string

    # methods:
    #   __init__()
    #   get_attributes()
    #   build_string()

    # init
    def __init__(self, string):
        self.type = "MEM Rd Req"
        self.get_attributes(string)
        self.build_string()
    
    # get attributes based on string
    def get_attributes(self, string):
        self.addr = leading_zeros(string[string.index("addr=") + len("addr="):string.index(", tag=")], 32//4)
        self.tag = string[string.index("tag=") + len("tag="):string.index(", byteen=")]

    # build string
    def build_string(self):
        self.string = ""
        self.string += self.type + ":"
        self.string += " "
        self.string += "addr=" + self.addr
        self.string += " "
        self.string += "tag=" + self.tag
        self.string += "\n"

# ~struct for mem write requests
class MEM_Wr_Req():

    # instance vars:
    #   type
    #   addr
    #   tag
    #   byteen
    #   data
    #   simple_data
    #   string

    # methods:
    #   __init__()
    #   get_attributes()
    #   build_string()

    # init
    def __init__(self, string):
        self.type = "MEM Wr Req"
        self.get_attributes(string)
        self.build_string()

    # get attributes based on string
    def get_attributes(self, string):
        self.addr = leading_zeros(string[string.index("addr=") + len("addr="):string.index(", tag=")], 32//4)
        self.tag = string[string.index("tag=") + len("tag="):string.index(", byteen=")]
        self.byteen = leading_zeros(string[string.index("byteen=") + len("byteen="):string.index(" data=")], 64//4)  # just space between byteen and data for some reason
        self.data = leading_zeros(string[string.index("data=") + len("data="):string.index("\n")], 512//4)
        self.get_simple_data()

    # get simple data attribute based on byteen and data
    def get_simple_data(self):
        
        # get int representation of byteen
        byteen_int = int(self.byteen, 16)

        # iterate through 64 bytes of data, adding x's or vals to simple data string
        self.simple_data = ""
        for byte in range(64):
            byte_idx = byte * 2

            # check for byte enabled
            if (byteen_int & (1 << (63-byte))):
                # put in vals
                self.simple_data += self.data[byte_idx:byte_idx + 2]
            else:
                # put in x's
                self.simple_data += "xx"

            # get next bit of byteen
            byteen_int >> 1

    # build string
    def build_string(self):
        self.string = ""
        self.string += self.type + ":"
        self.string += " "
        self.string += "addr=" + self.addr
        self.string += " "
        self.string += "tag=" + self.tag
        self.string += " "
        self.string += "byteen=" + self.byteen
        self.string += " "
        self.string += "data=" + self.simple_data
        self.string += "\n"

# ~struct for mem responses
class MEM_Rsp():

    # instance vars:
    #   type
    #   tag
    #   data
    #   string

    # methods:
    #   __init__()
    #   get_attributes()
    #   build_string()

    # init
    def __init__(self, string):
        self.type = "MEM Rsp"
        self.get_attributes(string)
        self.build_string()

    # get attributes based on string
    def get_attributes(self, string):
        self.tag = string[string.index("tag=") + len("tag="):string.index(", data=")]
        self.data = leading_zeros(string[string.index("data=") + len("data="):string.index("\n")], 512//4)

    # build string
    def build_string(self):
        self.string = ""
        self.string += self.type + ":"
        self.string += " "
        self.string += "tag=" + self.tag
        self.string += " "
        self.string += "data=" + self.data
        self.string += "\n"

# class for storing entire scraped trace
class Scrape():

    # init
    def __init__(self, file_name):
        self.file_name = file_name

        self.MEM_Trans_list = []

        self.MEM_Rd_Req_list = []

        self.MEM_Wr_Req_list = []

        self.MEM_Rsp_list = []
        
    # interpret trace line
    def interpret_line(self, line):

        # check if mem transaction
        if ("MEM" in line):

            # if (DO_PRINTS):
            #     print("MEM in line")

            # mem read req
            if ("Rd" in line):

                # if (DO_PRINTS):
                #     print("Rd in line")

                # collect mem read req
                try:
                    # get string
                    string = line[line.index("MEM"):]

                    # instantiate MEM_Rd_Req
                    new_mem_trans = MEM_Rd_Req(string=string)
                    self.MEM_Trans_list.append(new_mem_trans)
                    self.MEM_Rd_Req_list.append(new_mem_trans)
                    
                except:
                    # bad mem transaction
                    return False

            # MEM Wr Req
            elif ("Wr" in line):

                # if (DO_PRINTS):
                #     print("Wr in line")
                
                # collect mem write req
                try:
                    # get string
                    string = line[line.index("MEM"):]

                    # instantiate MEM_Rd_Req
                    new_mem_trans = MEM_Wr_Req(string=string)
                    self.MEM_Trans_list.append(new_mem_trans)
                    self.MEM_Wr_Req_list.append(new_mem_trans)

                except:
                    # bad mem transaction
                    return False

            # MEM Rsp
            elif ("Rsp" in line):

                # if (DO_PRINTS):
                #     print("Rsp in line")
                
                # collect mem read req
                try:
                    # get string
                    string = line[line.index("MEM"):]

                    # instantiate MEM_Rsp
                    new_mem_trans = MEM_Rsp(string=string)
                    self.MEM_Trans_list.append(new_mem_trans)
                    self.MEM_Rsp_list.append(new_mem_trans)

                except:
                    # bad mem transaction
                    return False

        # either got good mem transaction or no mem transaction, so success
        return True

    # print/file write output --> whenever str() called on object
    def __repr__(self):
        # output_string = f"scrape for {self.file_name}\n"
        output_string = ""

        # give all memory transactions
        output_string += "all memory transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Trans_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        # give memory read transactions
        output_string += "memory read request transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Rd_Req_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        # give memory write transactions
        output_string += "memory write request transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Wr_Req_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        # give memory response transactions
        output_string += "memory response transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Rsp_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        return output_string

###########################################################################################################
# funcs:

# add leading zeros to value if string shorter than expected width
def leading_zeros(string, width):

    # check for add leading zeros
    if (len(string) < width):
        return "0" * (width - len(string)) + string
    
    # otherwise, give string as-s
    else:
        return string

# generate scrape corresponding to trace file
def scrape_trace(file_name, trace_file_lines):
    
    # find lines that correspond to a memory transaction
    mem_trans_scrape = Scrape(file_name)
    for line_index in range(len(trace_file_lines)):

        # interpret this line
        success = mem_trans_scrape.interpret_line(trace_file_lines[line_index])
        if (not success):
            print(f"ERROR: failed to scrape line {line_index + 1}")
            return False

    # return scrape object
    return mem_trans_scrape

# compare rtlsim and questa scrape objects
def compare_scrapes(rtlsim_scrape, questa_scrape):

    print_lines = []

    # run comparison algo:

    # fetch rtlsim and questa mem transaction list strings
    rtlsim_trans_str_list = [x.string for x in rtlsim_scrape.MEM_Trans_list]
    questa_trans_str_list = [x.string for x in questa_scrape.MEM_Trans_list]

    # init mem transactions same
    same = True
    diff_count = 0

    # check for diff num mem transactions
    if (len(rtlsim_trans_str_list) != len(questa_trans_str_list)):

        # mem transactions diff
        same = False
        diff_count += 1

        # give line lengths
        print_lines += [
            f"DIFF:",
            f"\trtlsim: {len(rtlsim_trans_str_list)} mem transactions",
            f"\tquesta: {len(questa_trans_str_list)} mem transactions",
            f"",
        ]

    # otherwise, same num mem transactions
    else:
        print_lines += [
            f"SAME: scrapes have same num lines",
            f"",
        ]

    # go through each line of rtlsim and check same as corresponding questa line
    for line in range(len(rtlsim_trans_str_list)):

        # check for ran out of questa lines
        if (line >= len(questa_trans_str_list)):

            # check line exists in questa
            if (rtlsim_trans_str_list[line] in questa_trans_str_list):
                
                # notify of different ordering, but otherwise still match
                print_lines += [
                    f"SAME: Line {line + 1}: diff ordering, otherwise match (ran out of questa lines)"
                ]

            # check baadf00d line exists in questa
            elif (rtlsim_trans_str_list[line].replace("baadf00d", "00000000") in questa_trans_str_list):

                # notify of baadf00d, but otherwise still match
                print_lines += [
                    f"SAME: Line {line + 1}: diff ordering, undefined mem, otherwise match (ran out of questa lines)",
                ]

            # otherwise, line doesn't match
            else:
                same = False
                diff_count += 1

                # notify of line diff
                print_lines += [
                    f"DIFF: rtlsim Line {line + 1}: no matching questa line (ran out of questa lines)",
                ]
        
        # check for lines diff
        elif (rtlsim_trans_str_list[line] != questa_trans_str_list[line]):
            
            # check line exists in questa
            if (rtlsim_trans_str_list[line] in questa_trans_str_list):

                # notify of different ordering, but otherwise still match
                print_lines += [
                    f"SAME: Line {line + 1}: diff ordering, otherwise match"
                ]

                continue

            # replace baadf00d's with 0's in rtlsim line
            baadf00d_line = rtlsim_trans_str_list[line]
            baadf00d_line = baadf00d_line.replace("baadf00d", "00000000")

            # check lines diff again with baadf00d
            if (baadf00d_line == questa_trans_str_list[line]):

                # notify of baadf00d, but otherwise still match
                print_lines += [
                    f"SAME: Line {line + 1}: undefined mem, otherwise match",
                ]

            # otherwise, check baadf00d line exists in questa
            elif (baadf00d_line in questa_trans_str_list):
                
                # notify of different ordering, but otherwise still match
                print_lines += [
                    f"SAME: Line {line + 1}: diff ordering, undefined mem, otherwise match"
                ]
            
            # otherwise, this mem transaction diff
            else:
                same = False
                diff_count += 1

                # notify of line diff
                print_lines += [
                    f"DIFF: Line {line + 1}: no matching questa line",
                ]

                # print(baadf00d_line)

    # give final verdict on if mem transactions match
    if (same):
        # traces officially same
        print_lines = [
            f"",
            f"TRACE MATCH: rtlsim and questa traces match",
            # f"",
        ]
    else:
        # traces officially not same, notify of differences
        print_lines = [
            f"",
            f"NO TRACE MATCH: rtlsim and questa traces do not match",
            f"\t{diff_count} differences"
            # f"",
        ]

    # create MEM_Tracker object for both scrapes
    rtlsim_mem = MEM_Tracker()
    rtlsim_mem.simulate_writes(rtlsim_scrape.MEM_Wr_Req_list)
    questa_mem = MEM_Tracker()
    questa_mem.simulate_writes(questa_scrape.MEM_Wr_Req_list)

    if (rtlsim_mem.mem_state == questa_mem.mem_state):
        # mem states officially same
        print_lines += [
            # f"",
            f"MEM MATCH: rtlsim and questa memory states match",
            f"",
        ]
    else:
        # mem state officially not same
        print_lines += [
            # f"",
            f"NO MEM MATCH: rtlsim and questa memory states do not match",
            f"",
        ]

    # print all final equivalent scrape and mem info lines
    for line in print_lines:
        print(line)

# overall function to scrape rtlsim, scrape questa, compare scrapes, and write output files
def compare_trace_files(rtlsim_trace_file_name, questa_trace_file_name):

    # try to read rtlsim file lines
    try:
        with open(rtlsim_trace_file_name, "r") as rtlsim_trace_file_fp:
            rtlsim_trace_file_lines = rtlsim_trace_file_fp.readlines()
    except:
        print("ERROR: couldn't find rtlsim trace file")
        quit()

    # scrape rtlsim trace file
    rtlsim_scrape = scrape_trace(rtlsim_trace_file_name, rtlsim_trace_file_lines)

    # check for bad scrape
    if (not rtlsim_scrape):
        print("ERROR: failed rtlsim scrape")
        quit()

    if (DO_PRINTS):
        print("rtlsim scrape:")
        print(str(rtlsim_scrape))
        print()

    # try to read questa file lines
    try:
        with open(questa_trace_file_name, "r") as questa_trace_file_fp:
            questa_trace_file_lines = questa_trace_file_fp.readlines()
    except:
        print("ERROR: couldn't find questa trace file")
        quit()

    # scrape questa trace file
    questa_scrape = scrape_trace(questa_trace_file_name, questa_trace_file_lines)

    # check for bad scrape
    if (not questa_scrape):
        print("ERROR: failed questa scrape")
        quit()

    if (DO_PRINTS):
        print("questa scrape:")
        print(str(questa_scrape))
        print()

    # output respective scrape files (simplified trace) for commandline diff:

    # scrape file names based on input file names (can't do prefix if there is directory at beginning)
    rtlsim_scrape_file_name = rtlsim_trace_file_name + ".scrape.log"
    questa_scrape_file_name = questa_trace_file_name + ".scrape.log"
    
    # try to write rtlsim scrape file
    try:
        with open(rtlsim_scrape_file_name, "w") as rtlsim_scrape_file_fp:
            rtlsim_scrape_file_fp.write(str(rtlsim_scrape))

    except: 
        print("ERROR: couldn't write rtlsim scrape file")
        quit()

    # try to write questa scrape file
    try:
        with open(questa_scrape_file_name, "w") as questa_scrape_file_fp:
            questa_scrape_file_fp.write(str(questa_scrape))

    except:
        print("ERROR: couldn't write questa scrape file")
        quit()

    # compare rtlsim and questa scrapes and print difference information
    compare_scrapes(rtlsim_scrape, questa_scrape)

    # done program
    return

###########################################################################################################
# main:

if __name__ == "__main__":

    # check for don't have required commandline arguments
    if (len(sys.argv) < 3):
        print("ERROR: need to follow commandline format:")
        print("python3 scrape_traces.py <rtlsim trace file> <questa trace file> <flags>")
        quit()

    # collect flags
    if ("-p" in sys.argv):
        DO_PRINTS = True

    if (DO_PRINTS):
        print(f"DO_PRINTS = {DO_PRINTS}")
        print()

    # run program
    compare_trace_files(sys.argv[1], sys.argv[2])