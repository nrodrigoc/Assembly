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
    a dword 0 ; Variavel para armazenar numero qualquer
    be dword 20
    ce dword 30

.code
start:
    mov eax, a
    add eax, be
    add eax, ce
    add eax, 100
    mov a, eax

    printf("a: %d\n", a)
 
    invoke ExitProcess, 0
end start