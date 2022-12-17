[org 0x7c00]
[bits 16]

;Boot Loader
mov bx,0x1000
mov ah,0x02
mov al,30
mov ch,0x00
mov dh,0x00
mov cl,0x02

int 0x13

;switch to protected mode
cli
lgdt [GDT_DESC]

mov eax,cr0
or eax,0x1
mov cr0, eax
jmp CODE_SEG:INIT_PM

;Forces the cpu to flush out content in the cache memory

[bits 32]
INIT_PM:
mov ax,DATA_SEG
mov ds,ax
mov ss,ax
mov es,ax
mov fs,ax
mov gs,ax

mov ebp,0x90000
mov esp,ebp

call 0x1000
jmp $

GDT_BEGIN:
GDT_NULL_DESC:
    dd 0x0
    dd 0x0

GDT_CODE_SEG:
    dw 0xffff
     dw 0x0
     db 0x0
     db 10011010b
     db 11001111b
     db 0x0
GDT_DATA_SEG:
      dw 0xffff
     dw 0x0
     db 0x0
     db 10011010b
     db 11001111b
     db 0x0
GDT_END:

GDT_DESC:
      dw GDT_END - GDT_BEGIN - 1
      dd GDT_BEGIN

 CODE_SEG equ GDT_CODE_SEG - GDT_BEGIN          
 DATA_SEG equ GDT_DATA_SEG - GDT_BEGIN 
 start_protected_mode:
 mov al, 'A'
 mov ah, 0x0f

 times 510-($-$$) db 0
 dw 0xaa55