import sys
import re

def convert_to_obj(input_file_path, output_file_path):
    """
    Converts a text file of LC-3 binary strings into a binary .obj file.
    """
    print(f"Starting conversion: {input_file_path} -> {output_file_path}")
    
    try:
        with open(input_file_path, 'r') as infile, open(output_file_path, 'wb') as outfile:
            line_number = 0
            for line in infile:
                line_number += 1
                
                # Remove comments
                line = line.split(';', 1)[0]
                
                # Remove all whitespace
                bin_string = re.sub(r'[\s.]+', '', line)
                
                # Skip empty lines
                if not bin_string:
                    continue
                    
                # Validate the binary string
                if len(bin_string) != 16:
                    print(f"Error on line {line_number}: Expected 16 bits, but found {len(bin_string)} ('{bin_string}')")
                    return False
                
                if not all(c in '01' for c in bin_string):
                    print(f"Error on line {line_number}: Invalid characters found in binary string ('{bin_string}')")
                    return False
                
                # Convert 16-bit string to an integer
                value = int(bin_string, 2)
                
                # Pack the integer into 2 bytes (big-endian)
                packed_bytes = value.to_bytes(2, byteorder='big')
                
                # Write the bytes to the output file
                outfile.write(packed_bytes)
                
        print(f"\nSuccess! Created {output_file_path}")
        return True

    except FileNotFoundError:
        print(f"Error: Input file not found at '{input_file_path}'")
        return False
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return False



if len(sys.argv) != 3:
    print("Needs 3 arguments.")
    sys.exit(1)
    
input_file = sys.argv[1]
output_file = sys.argv[2]

convert_to_obj(input_file, output_file)

