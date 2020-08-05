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
    contador dword 0 ; Variavel para armazenar numero qualquer
    soma dword 0

.code
start:
    mov eax, soma
then:
    inc contador
    add soma, contador
    cmp contador, 100
    jg then

    mov eax, soma
    printf("EAX: %d\n", eax)
    printf("EDX: %d\n", edx)
    invoke ExitProcess, 0
end start