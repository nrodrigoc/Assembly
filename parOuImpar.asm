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
    x dword 2 ; Variavel para armazenar numero qualquer
    resto dword 0

.code
start:

    mov eax, 13
    mov edx, 0
    div x
    cmp edx, 0
    jne impar

    printf("PAR\n")
    invoke ExitProcess, 0


impar:
    printf("IMPAR\n") 
    invoke ExitProcess, 0


end start