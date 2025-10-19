; -----------------------------------
; Torre de Hanoi 
; Dupla : Beatriz Mergulhão e Luiza Trigueiro
; -----------------------------------

BITS 32

section .text
global _start

_start:
    ; Mensagem inicial
    mov edx, lenMensagem
    mov ecx, mensagem
    mov ebx, 1          ; stdout
    mov eax, 4          ; sys_write
    int 0x80

    ; Prompt
    mov edx, lenInput
    mov ecx, input
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 2
    mov ecx, num
    mov ebx, 0          ; stdin
    mov eax, 3          ; sys_read
    int 0x80

    movzx eax, byte [num]
    sub eax, '0'
    cmp eax, 0
    jne l1

    ; Erro
    mov edx, lenCaso_zero
    mov ecx, caso_zero
    mov ebx, 1
    mov eax, 4
    int 0x80
    jmp fim

l1:
    ; eax = n (1..9), ebx='A', ecx='C', edx='B'
    mov ebx, 'A'
    mov ecx, 'C'
    mov edx, 'B'
    call hanoi

    ; Mensagem final
    mov edx, lenDone
    mov ecx, done_message
    mov ebx, 1
    mov eax, 4
    int 0x80

fim:
    mov eax, 1          ; sys_exit
    mov ebx, 0
    int 0x80


; ------------------------------------------------
; hanoi(n=EAX, orig=EBX, dest=ECX, aux=EDX)
; - usa apenas registradores; salva/recupera com push/pop
; ------------------------------------------------
hanoi:
    cmp eax, 0
    je  .ret

    ; --- 1ª recursão: hanoi(n-1, orig, aux, dest)
    push eax
    push ebx
    push ecx
    push edx

    dec eax
    xchg ecx, edx       ; dest <-> aux
    call hanoi

    ; restaurar originais
    pop edx
    pop ecx
    pop ebx
    pop eax

    ; --- imprimir movimento (orig->dest) ---
    push eax
    push ebx
    push ecx
    push edx

    add al, '0'
    mov [disco], al
    mov [torre_origem], bl
    mov [torre_destino], cl

    mov edx, lenMoverDisco
    mov ecx, mover_disco
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax

    ; --- 2ª recursão: hanoi(n-1, aux, dest, orig)
    ; Precisamos dos valores ORIGINAIS (já estão nos registradores)
    push eax
    push ebx
    push ecx
    push edx

    dec eax                 ; n-1
    mov ebx, edx            ; novo orig = aux (original)
    ; ecx (dest) permanece o mesmo
    mov edx, [esp+8]        ; novo aux = orig (original)  (pilha: esp=edx, +4=ecx, +8=ebx, +12=eax)
    call hanoi

    pop edx
    pop ecx
    pop ebx
    pop eax

.ret:
    ret


section .bss
    num resb 2

section .data
    mensagem db "ALGORITMO DA TORRE DE HANOI ", 13, 10
    lenMensagem equ $-mensagem

    input db "Digite uma quantidade de discos entre 1 e 9: ", 13
    lenInput equ $-input

    mover_disco db "Mova o disco "
    disco       db "0"
                 db " da torre "
    torre_origem db "A"
                 db " para a torre "
    torre_destino db "B", 10
    lenMoverDisco equ $-mover_disco

    caso_zero    db "Digite um numero de discos valido quando for rodar o programa novamente :(", 10
    lenCaso_zero equ $-caso_zero

    done_message db 10, "Concluido! :)", 13
    lenDone      equ $-done_message
