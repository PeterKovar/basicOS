; boot.asm - Multiboot-kompatibler Kernel Entry Point

MBALIGN  equ  1 << 0              ; Multiboot-Header ausrichten
MEMINFO  equ  1 << 1              ; Speicherinfo anfordern
FLAGS    equ  MBALIGN | MEMINFO   ; Multiboot-Flags
MAGIC    equ  0x1BADB002          ; Multiboot-Magic-Number
CHECKSUM equ -(MAGIC + FLAGS)     ; Checksum für Multiboot

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .bss
align 16
stack_bottom:
resb 16384  ; 16 KB Stack
stack_top:

section .text
global _start:function (_start.end - _start)
_start:
    ; Stack-Pointer setzen
    mov esp, stack_top

    ; Kernel-Hauptfunktion aufrufen
    extern kernel_main
    call kernel_main

    ; Falls kernel_main zurückkehrt: CPU anhalten
    cli
.hang:
    hlt
    jmp .hang
.end:
