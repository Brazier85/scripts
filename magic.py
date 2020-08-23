#!/usr/bin/env python3

# Add some magic numbers to a file. So you can hide it in some cases

import argparse

# Building the magic number dict
magic = {}
magic.update({"gif": bytearray([0x47,0x49,0x46,0x38,0x37,0x61])})
magic.update({"jpg": bytearray([0xff,0xd8,0xff,0xe0,0x00,0x10,0x4a,0x46,0x49,0x46,0x00,0x01,0x01,0x00,0x00,0x01])})
magic.update({"png": bytearray([0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A])})
magic.update({"psd": bytearray([0x38,0x42,0x50,0x53])})
magic.update({"tif": bytearray([0x49,0x49,0x2A,0x00])})


# Known numbers as text
numbers = " ".join(list(magic.keys()))

# Argparse for better script handling
parser = argparse.ArgumentParser(description='Add some magic to your file...', epilog=f"I know the numbers for: {numbers}")
parser.add_argument('-m', '--magic', dest='magic', type=str.lower, help='Pure magic', required=True)
parser.add_argument('-s', '--source', dest='source', help='The source file', required=True)
parser.add_argument('-d', '--destination', dest='dest', help='The destination file', required=True)

# Parsing the args
args = parser.parse_args()
source = args.source
dest = args.dest

# Check if the selected magic number is known
try:
    magicnumber = magic[args.magic]
except:
    print(f"I don't know the magic number for \"{args.magic}\"!")
    print(f"I know the numbers for: {numbers}")
    exit()

# Reading the source file
with open(source, "rb") as h:
        content = h.read()

# Writing the desitination file
with open(dest, "wb") as h:
    h.write(magicnumber + content)
