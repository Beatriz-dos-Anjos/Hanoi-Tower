; -----------------------------------
; Resolução Torre de Hanoi - Assembly x86_64
; -----------------------------------

section .text
global _start 

_start:        
    ; Mensagem Inicial
    mov rax, 1
    mov rdi, 1
    mov rsi, mensagem
    mov rdx, lenMensagem
    syscall

    ; Solicita número de discos
    mov rax, 1
    mov rdi, 1
    mov rsi, input
    mov rdx, lenInput
    syscall

    ; Lê entrada
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 2
    syscall

    ; Verifica se é válido
    movzx rax, byte [num]
    sub rax, '0'
    cmp rax, 0
    jg comecar_hanoi
    
    ; Mensagem de erro
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_erro
    mov rdx, lenErro
    syscall
    jmp fim

comecar_hanoi:
    movzx r12, byte [num]      ; r12 = número de discos
    sub r12, '0'
    mov r13, 'A'               ; r13 = origem
    mov r14, 'C'               ; r14 = destino
    mov r15, 'B'               ; r15 = auxiliar
    
    call hanoi_modificado

    ; Mensagem final
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_final
    mov rdx, lenFinal
    syscall
    
fim:
    mov rax, 60
    mov rdi, 0
    syscall

; ===================================
; FUNÇÃO HANOI MODIFICADA
; ===================================
; r12 = discos, r13 = origem, r14 = destino, r15 = auxiliar

hanoi_modificado:
    cmp r12, 1
    jl fim_recursao

    ; Caso base: se n == 1, move direto
    cmp r12, 1
    je mover_disco_unico

    ; Primeira recursão: hanoi(n-1, origem, auxiliar, destino)
    push r12
    push r13
    push r14
    push r15
    
    dec r12                    ; n-1
    xchg r14, r15              ; troca destino e auxiliar
    
    call hanoi_modificado
    
    pop r15
    pop r14
    pop r13
    pop r12

    ; Move disco atual
    call mostrar_movimento

  ; Segunda recursão desejada: hanoi(n-1, meio, inicial, final)
push r12
push r13
push r14
push r15

dec r12

; queremos: r13 = meio (r15 antigo), r14 = inicial (r13 antigo), r15 = final (r14 antigo)

mov rbx, r15     ; salva MEIO
mov rcx, r13     ; salva INICIAL
mov rdx, r14     ; salva FINAL

mov r13, rbx     ; origem  = meio
mov r14, rcx     ; destino = inicial
mov r15, rdx     ; auxiliar = final

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

; ===================================
; MOSTRAR MOVIMENTO
; ===================================
mostrar_movimento:
    ; Prepara mensagem
    mov rax, r12
    add al, '0'
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

section .bss
    num resb 2

section .data
    mensagem db "RESOLUCAO TORRE DE HANOI - Versao Corrigida", 10
    lenMensagem equ $-mensagem

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
