import binascii

def bin_to_hex(binary_file_path, output_hex_path):
    with open(binary_file_path, 'rb') as infile, open(output_hex_path, 'w') as outfile:
        max_data_bytes = 4
        address = 0
        data = ''

        for byte in infile.read():
                data += '{:02X}'.format(byte)
                if len(data) == max_data_bytes * 2:
                    record_length = max_data_bytes
                    record_checksum = (record_length + (address >> 8) + (address & 0xFF) + sum(int(data[i:i+2], 16) for i in range(0, len(data), 2))) & 0xFF
                    record_data = ':{:02X}{:04X}00{}{:02X}\n'.format(record_length, address, data, (0x100 - record_checksum) & 0xFF)
                    outfile.write(record_data)
                    address += 1 #=> word addressing or max_data_bytes => byte addressing
                    data = ''

        if len(data) > 0:
            record_length = len(data) // 2
            record_checksum = (record_length + (address >> 8) + (address & 0xFF) + sum(int(data[i:i+2], 16) for i in range(0, len(data), 2))) & 0xFF
            outfile.write(':{}{:04X}00{}{:02X}\n'.format(record_length, address, data, (0x100 - record_checksum) & 0xFF))
        outfile.write(':00000001FF\n')

def hex_to_hex(input_hex_path, output_hex_path):
    with open(input_hex_path, 'r') as infile, open(output_hex_path, 'w') as outfile:
        max_data_bytes = 4
        address = 0
        data = ''

        for line in infile:
            line = line.strip()
            binary_data = binascii.unhexlify(line)
            for byte in binary_data:
                data += '{:02X}'.format(byte)
                if len(data) == max_data_bytes * 2:
                    record_length = max_data_bytes
                    record_checksum = (record_length + (address >> 8) + (address & 0xFF) + sum(int(data[i:i+2], 16) for i in range(0, len(data), 2))) & 0xFF
                    record_data = ':{:02X}{:04X}00{}{:02X}\n'.format(record_length, address, data, (0x100 - record_checksum) & 0xFF)
                    outfile.write(record_data)
                    address += 1 #=> word addressing | max_data_bytes => byte addressing
                    data = ''

        if len(data) > 0:
            record_length = len(data) // 2
            record_checksum = (record_length + (address >> 8) + (address & 0xFF) + sum(int(data[i:i+2], 16) for i in range(0, len(data), 2))) & 0xFF
            outfile.write(':{}{:04X}00{}{:02X}\n'.format(record_length, address, data, (0x100 - record_checksum) & 0xFF))
        outfile.write(':00000001FF\n')

def large_hex_small_hex(input_hex_path, output_hex_path):
    with open(input_hex_path, 'r') as infile, open(output_hex_path, 'w') as outfile:
        max_data_bytes = 4

        for line in infile:
            record_length = int(line[1:3], 16)
            address = int(line[3:7], 16)
            record_type = int(line[7:9], 16)
            data = line[9:9+record_length*2]

            if record_type == 0:
                while len(data) > 0:
                    chunk = data[:max_data_bytes*2]
                    write_hex_record(outfile, address, chunk)
                    address += 1 #=> word addressing | len(chunk) // 2 => byte addressing
                    data = data[len(chunk):]
            else:
                outfile.write(line)

        # outfile.write(':00000001FF\n') #already present in the input file

def write_hex_record(outfile, address, data):
    record_length = len(data) // 2
    record_checksum = (record_length + (address >> 8) + (address & 0xFF) + sum(int(data[i:i+2], 16) for i in range(0, len(data), 2))) & 0xFF
    outfile.write(':{:02X}{:04X}00{}{:02X}\n'.format(record_length, address, data, (0x100 - record_checksum) & 0xFF))

if __name__ == '__main__':
    # bin_to_hex('memtest.hex', 'meminit.hex')
    large_hex_small_hex('memtest.hex', 'meminit.hex')