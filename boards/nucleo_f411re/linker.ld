
MEMORY {
    FLASH   (rx)    : ORIGIN = 0x08000000, LENGTH = 512K
    RAM     (rwx)   : ORIGIN = 0x20000000, LENGTH = 128K
}
 
/* Point to top of stack / end of RAM (Cortex-M implements full-descending stack) */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {
    /* Vector table (must be first in Flash) */
    .isr_vector :
    {
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* Program code */
    .text :
    {
        *(.text*)
        . = ALIGN(4);
    } > FLASH

    /* Read-only data */
    .rodata :
    {
        *(.rodata*)
        . = ALIGN(4);
        _flash_lma_end = .;
    } > FLASH

    /* Initialized data
        - Stored in FLASH in the image (LMA)
        - Lives in RAM at runtime (VMA) */
    .data : AT(_flash_lma_end)
    {
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM

    /* Point to Initialized data values in FLASH (LMA) */
    _sidata = LOADADDR(.data);

    /* Zero-Initialized data (no FLASH image needed) */
    .bss :
    {
        _sbss = .;
        *(.bss*) 
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM
}