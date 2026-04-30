/* linker.ld - Linker-Skript für den Kernel */

ENTRY(_start)

SECTIONS
{
    /* Kernel beginnt bei 1 MB */
    . = 1M;

    /* Multiboot-Header muss am Anfang stehen */
    .boot :
    {
        *(.multiboot)
    }

    /* Text-Sektion (Code) */
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.text)
    }

    /* Read-only Daten */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* Initialisierte Daten */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* Nicht-initialisierte Daten (BSS) */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}
