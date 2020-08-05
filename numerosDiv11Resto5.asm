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


; Este programa em assembly imprime todos os numeros entre 1000 e 1999 que divididos por 11 tem resto 5

.data
    contador dword 1000
    divisor dword 11

.code
start:
proximo:
    inc contador
    mov edx, 0
    mov eax, contador
    div divisor
    cmp edx, 5
    je imprime
    
    mov eax, contador
    cmp eax, 1999
    jl proximo
    invoke ExitProcess, 0



imprime:
    printf("Numero: %d\n", contador)
    mov eax, contador
    cmp eax, 1999
    jl proximo


end start