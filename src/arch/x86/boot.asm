bits 32

MODULEALIGN equ 1 << 0
MEMINFO     equ 1 << 1
FLAGS       equ MODULEALIGN | MEMINFO
MAGIC       equ 0x1BADB002
CHECKSUM    equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .text
global _start
global gdt_flush
global idt_load
extern kernel_main

_start:
    mov esp, stack_top
    call kernel_main

.hang:
    cli
    hlt
    jmp .hang

gdt_flush:
    mov eax, [esp + 4]
    lgdt [eax]
    jmp 0x08:.reload_cs
.reload_cs:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    ret

idt_load:
    mov eax, [esp + 4]
    lidt [eax]
    ret

global keyboard_handler_asm
extern keyboard_handler

keyboard_handler_asm:
    pusha
    push ds
    push es
    push fs
    push gs

    mov ax, 0x10
    mov ds, ax
    mov es, ax

    call keyboard_handler

    pop gs
    pop fs
    pop es
    pop ds
    popa
    iretd
