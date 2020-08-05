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
    message db "O resultado da soma eh:", 0H
    newLine db 0AH ;
    request1 db "Digite um numero inteiro:", 0H
    request2 db "Digite outro numero inteiro:", 0H
    repete db "Deseja fazer uma nova operacao? 1 (Sim) / 0 (Nao)", 0H
    fimProg db "Programa finalizado!", 0AH

    op1 dd 0 ; Variavel local operando 1
    op2 dd 0 ; Variavel local operando 2
    novaConsulta dd 0 ; Variavel para armazenar

    ; Variaveis para receber informacoes do console ou envia-las a ele
    inputString db 10 dup(0)
    outputString db 10 dup(0)
    inputHandle dd 0
    outputHandle dd 0
    console_count dd 0
    tam_outputString dd 0

.code
start:

laco:  ; Inicio de uma nova operacao, caso solicitada pelo usuario
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

    invoke WriteConsole, outputHandle, addr request1, sizeof request1, addr console_count, NULL      ; Imprime na tela a string request1
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL  ; Aloca na var inputString a resposta do usuario

    call strToNumber  ; Chama a funcao para colocar no registrador eax a conversao para binario da string lida
    mov op1, eax 

    invoke WriteConsole, outputHandle, addr request2, sizeof request2, addr console_count, NULL      ; Imprime na tela a string request2
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL  ; Aloca na var inputString a resposta do usuario

    call strToNumber
    mov op2, eax
    

    push op1          ; Empilha o primeiro operando a ser usado como parametro da funcao soma
    push op2          ; Empilha o segundo operando a ser usado como parametro da funcao soma

    call soma ; chama a funcao soma

    invoke dwtoa, eax, addr outputString

    invoke StrLen, addr outputString
    mov tam_outputString, eax

    ; Inicio da impressao do resultado
    invoke WriteConsole, outputHandle, addr message, sizeof message, addr console_count, NULL
    invoke WriteConsole, outputHandle, addr outputString, tam_outputString, addr console_count, NULL
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL
    ; Fim da impressao do resultado

    
    ; Pergunta acerca de nova operacao
    invoke WriteConsole, outputHandle, addr repete, sizeof repete, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL
    ; Fim pergunta

    call strToNumber
    cmp eax, 1
    je laco

    invoke WriteConsole, outputHandle, addr fimProg, sizeof fimProg, addr console_count, NULL ; Exibe mensagem de finalizacao

    
    invoke ExitProcess, 0



; Inicio funcao para transformar entrada string em numero inteiro
strToNumber:
    mov esi, offset inputString ; Armazenar apontador da string em esi
    proximo:
    mov al, [esi] ; Mover caracter atual para al
    inc esi ; Apontar para o proximo caracter
    cmp al, 48 ; Verificar se menor que ASCII 48 - FINALIZAR
    jl terminar
    cmp al, 58 ; Verificar se menor que ASCII 58 - CONTINUAR
    jl proximo
    
    terminar:
    dec esi ; Apontar para caracter anterior
    xor al, al ; 0 ou NULL
    mov [esi], al ; Inserir NULL logo apos o termino do numero
    invoke atodw, addr inputString
    ret
; fim da funcao


; Inicio funcao soma
soma:
    push ebp
    mov ebp, esp
    sub esp, 8

    mov eax, DWORD PTR [ebp+12]
    add eax, DWORD PTR [ebp+8]

    mov esp, ebp
    pop ebp
    ret 8 ; Desaloca os 2 parametros
    
; Fim funcao soma 

    


end start