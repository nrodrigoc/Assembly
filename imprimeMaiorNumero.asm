.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data
    x1 dword 12 ; Variavel para armazenar numero qualquer
    x2 dword 14

.code
start:
    mov eax, x1
    cmp eax, x2 ;Se x1 eh menor que x2...
    jle maior
    printf("X1: %d\n", x1) 
    jmp fim


maior:
    printf("X2: %d\n", x2) 
    jmp fim



fim:
    invoke ExitProcess, 0


end start