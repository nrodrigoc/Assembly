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
    strPrimo db "O numero informado eh primo:", 0H, 0AH
    strNPrimo db "O numero informado nao eh primo", 0H, 0AH
    request db "Digite um numero inteiro:", 0H
    repete db "Deseja fazer uma nova operacao? 1 (Sim) / 0 (Nao)", 0H
    newLine db 0AH
    fimProg db "Programa finalizado!", 0AH

    
    op dd 0 ; Variavel local para o operando
    novaConsulta dd 0 ; Variavel para armazenar resposta de nova consulta

    ; Variaveis para receber informacoes do console ou envia-las a ele
    inputString db 10 dup(0)
    inputHandle dd 0
    outputHandle dd 0
    console_count dd 0

.code
start:

inicio:  ; Inicio de uma nova operacao, caso solicitada pelo usuario
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

    invoke WriteConsole, outputHandle, addr request, sizeof request, addr console_count, NULL      ; Imprime na tela a string request
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL  ; Aloca na var inputString a resposta do usuario

    call strToNumber  ; Chama a funcao para colocar no registrador eax a conversao para binario da string lida
    mov op, eax

    push op         ; Empilha o operando a ser usado como parametro da funcao soma
    call verificaPrimo ; chama a funcao para verificar se o numero eh primo

    
    
    ; Pergunta acerca de nova operacao
    invoke WriteConsole, outputHandle, addr repete, sizeof repete, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL ; Quebra de linha
    ; Fim pergunta

    call strToNumber
    cmp eax, 1
    je inicio

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


; Inicio funcao verificaPrimo
verificaPrimo:
    ; Prologo sub-rotina
    push ebp
    mov ebp, esp
    sub esp, 4
    ; Fim prologo

    mov DWORD PTR [ebp-4], 1
    mov eax, DWORD PTR [ebp+8]
    cmp eax, DWORD PTR [ebp-4]
    je ehPrimo

proxDivisor:
    inc DWORD PTR [ebp-4]
    mov eax, DWORD PTR [ebp+8]
    cmp eax, DWORD PTR [ebp-4]
    je ehPrimo ; Finaliza o laco caso o contador chegue ao mesmo valor do parametro 
    
    mov edx, 0
    mov eax, DWORD PTR [ebp+8]
    div DWORD PTR [ebp-4]
    cmp edx, 0
    je nPrimo ; Finaliza o laco se o resto da divisao for diferente de 0

    jmp proxDivisor ; Inicia outra iteracao ate que o contador atinja o valor

    
   

ehPrimo:
    invoke WriteConsole, outputHandle, addr strPrimo, sizeof strPrimo, addr console_count, NULL
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL
    mov eax, 1

    mov esp, ebp
    pop ebp
    ret 4 ; Desaloca o parametro

nPrimo:
    invoke WriteConsole, outputHandle, addr strNPrimo, sizeof strNPrimo, addr console_count, NULL
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL
    mov eax, 0

    mov esp, ebp
    pop ebp
    ret 4 ; Desaloca o parametro 
    
; Fim funcao verificaPrimo 
    


end start