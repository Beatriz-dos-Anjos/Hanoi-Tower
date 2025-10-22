; Resolução Torre de Hanoi - Assembly x86_64

section .text
global _start 

_start:        
    ; Mensagem Inicial
    mov rax, 1 ; Indica chamada de sistema (syscall) para escrever
    mov rdi, 1 ; Indica o destino onde será escrito (na saída padrão - terminal)
    mov rsi, mensagem ; Pega o conteúdo de mensagem e coloca o endereço dela no registrador
    mov rdx, lenMensagem ; Indica o tamanho da mensagem, para o sistema saber quantos caracteres imprimir
    syscall

    ; Solicita número de discos
    mov rax, 1
    mov rdi, 1
    mov rsi, input
    mov rdx, lenInput
    syscall

    ; Lê entrada
    mov rax, 0
    mov rdi, 0 ; Leitura será feita pelo que o usuário digitar
    mov rsi, num ; Indica onde guardar a entrada do usuário
    mov rdx, 2 ; Indica quantos caracteres o sistema irá ler (buffer de leitura)
    syscall

    ; Verifica se é válido
    movzx rax, byte [num] ; Pega valor menor e joga dentro de um registrador maior, e preenchendo os dados restantes por 0
    sub rax, '0' ; Pega o valor do input e subtrai por 48 (valor de 0 em ACS)
    cmp rax, 0 ; Compara se o valor em rax é igual a 0
    jg comecar_hanoi ; Salta para hanoi caso o valor seja maior que zero (jump if greater)
    
    ; Mensagem de erro
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_erro
    mov rdx, lenErro
    syscall
    jmp fim

comecar_hanoi:
    movzx r12, byte [num] ; r12 = número de discos
    sub r12, '0' ; Transforma caractere do usuário em número
    mov r13, 'A' ; r13 = origem
    mov r14, 'C' ; r14 = destino
    mov r15, 'B' ; r15 = auxiliar
    
    call hanoi_modificado

    ; Mensagem final
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_final
    mov rdx, lenFinal
    syscall
    
fim:
    mov rax, 60 ; Comando para terminar programa
    mov rdi, 0 ; Define valor de retorno
    syscall

; Função hanoi
; r12 = discos, r13 = origem, r14 = destino, r15 = auxiliar

hanoi_modificado:
    cmp r12, 1
    jl fim_recursao ; Se número de discos for menor que 1, pula pro final (jump if less)

    ; Caso base: se n == 1, move direto
    cmp r12, 1
    je mover_disco_unico 


    ; Primeira recursão: hanoi(n-1, origem, auxiliar, destino)
    push r12
    push r13
    push r14
    push r15
    
    dec r12                    ; n-1
    xchg r14, r15              ; Transforma torre de destino em torre auxiliar
    
    call hanoi_modificado
    
    pop r15
    pop r14
    pop r13
    pop r12

    ; Move disco atual
    call mostrar_movimento

  ; Segunda recursão desejada: hanoi(n-1, auxiliar, origem, destino)
push r12
push r13
push r14
push r15

dec r12

; queremos: r13 = auxiliar (r15 antigo), r14 = origem (r13 antigo), r15 = destino (r14 antigo)

mov rbx, r15     ; salva destino
mov rcx, r13     ; salva auxiliar
mov rdx, r14     ; salva origem

mov r13, rbx   
mov r14, rcx   
mov r15, rdx  

call hanoi_modificado

pop r15
pop r14
pop r13
pop r12

    ret

mover_disco_unico:
    call mostrar_movimento

fim_recursao:
    ret

; Mostrar movimento

mostrar_movimento:
    ; Prepara mensagem
    mov rax, r12
    add al, '0' ; Soma 0 a valor de al
    mov [disco_num], al
    mov [torre_origem], r13b
    mov [torre_destino], r14b

    ; Exibe movimento
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_movimento
    mov rdx, lenMovimento
    syscall
    ret

section .bss ; Declara variáveis sem valor definido
    num resb 2 ; Reserva 2 bytes na variável

section .data ; Dados sempre disponíveis e que não mudam 
    mensagem db "RESOLUCAO TORRE DE HANOI", 10 ; Define sequência de bytes na memória
    lenMensagem equ $-mensagem ; Pega posição atual da memória - a primeira posição da mensagem

    input db "Digite o numero de discos (1-9): "
    lenInput equ $-input

    msg_erro db "Numero invalido! Use valores de 1 a 9.", 10
    lenErro equ $-msg_erro

    msg_final db 10, "Execucao concluida com sucesso!", 10
    lenFinal equ $-msg_final

    msg_movimento db "Mover disco "
    disco_num db "0"
              db " de "
    torre_origem db "A"
              db " para "
    torre_destino db "B", 10
    lenMovimento equ $-msg_movimento
