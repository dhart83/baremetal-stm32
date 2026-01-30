# Memory Map

This document describes the memory layout used by `baremetal-stm32` on the
**NUCLEO-F411RE (STM32F411RE, Cortex-M4)**, and how the linker script maps
firmware sections into **FLASH** and **RAM**.

The goal is to make the placement of `.isr_vector`, `.text`, `.rodata`, `.data`,
and `.bss` explicit and verifiable.

---

## 1. Hardware Memory Regions

The STM32F411RE exposes memory-mapped regions. This project uses:

- **FLASH** (non-volatile): holds the firmware image (vector table, code, constants, init data template)
- **SRAM** (volatile): holds runtime writable state (stack, `.data`, `.bss`, heap if used later)

### Region Summary

| Region |  Base Address |   Size | Purpose                                                           |
| -----: | ------------: | -----: | ----------------------------------------------------------------- |
|  FLASH | `0x0800_0000` | 512 KB | Firmware image storage (code + constants + `.data` init template) |
|   SRAM | `0x2000_0000` | 128 KB | Runtime writable memory (`.data`, `.bss`, stack)                  |

---

## 2. Linker Script Regions (`MEMORY {}`)

The linker script defines two regions:

```ld
MEMORY {
    FLASH   (rx)    : ORIGIN = 0x08000000, LENGTH = 512K
    RAM     (rwx)   : ORIGIN = 0x20000000, LENGTH = 128K
}
```

- `FLASH (rx)` = read/execute region for runtime code + read-only data
- `RAM (rwx)` = read/write/execute region for runtime data and stack

---

## 3. Runtime vs Image Addresses (VMA vs LMA)

Some sections have one address, others effectively have two.

### Definitions

**VMA (Virtual Memory Address)**: where the CPU accesses the section at runtime.

**LMA (Load Memory Address)**: where the section’s bytes live in the firmware image.

Most sections placed in FLASH have **VMA** == **LMA** (execute/read in place).

`.data` is special:

- `.data` **VMA is in RAM** (writable at runtime)
- `.data` **LMA is in FLASH** (initial values stored in the image)

Startup code bridges the gap by copying `.data` from FLASH (LMA) → RAM (VMA).

---

## 4. Section Placement Overview

### FLASH (Image + runtime-in-place)

| Output Section | Lives In | Purpose                                                                     |
| -------------: | -------- | --------------------------------------------------------------------------- |
|  `.isr_vector` | FLASH    | Vector table (initial SP + exception/IRQ handlers). Must be first in FLASH. |
|        `.text` | FLASH    | Instructions / code.                                                        |
|      `.rodata` | FLASH    | Read-only constants (string literals, `const` globals, tables).             |

These are executed/read directly from FLASH at runtime, so no copy is required.

### RAM (Runtime)

| Output Section | Lives In (VMA) | Purpose                                                |
| -------------: | -------------- | ------------------------------------------------------ |
|        `.data` | RAM            | Writable globals/statics with non-zero initial values. |
|         `.bss` | RAM            | Writable globals/statics that start as zero.           |

---

## 5. `.data` Dual Placement (Why LMA != VMA)

`.data` exists in two forms:

- **Template bytes in FLASH (LMA)**: the initialization values (what `.data` should start as)
- **Live storage in RAM (VMA)**: the writable variables used by the program

Startup code must:

1. Copy `.data` init bytes from FLASH → RAM
2. Zero `.bss` in RAM
3. Jump to `main`

### Symbols used for `.data`

- `_sidata` = start address of `.data` init bytes in FLASH (LMA)
- `_sdata` = start of `.data` in RAM (VMA)
- `_edata` = end of `.data` in RAM (VMA)

Startup copy loop typically uses:

```c
src = &_sidata;
dst = &_sdata;

while(dst < &_edata) {
    *dst++ = *src++;
}
```

---

## 6. `.bss` (Why No FLASH Image)

`.bss` is zero-initialized by definition.
It has no stored init bytes in FLASH.

## Symbols used for `.bss`

- `_sbss` = start of `.bss` in RAM
- `_ebss` = end of `.bss` in RAM

Startup zero loop:

```c
dst = &_sbss;

while (dst < &_ebss) {
    *dst++ = 0;
}
```

---

## 7. Stack Placement (`_estack`)

The Cortex-M uses a full-descending stack (grows downward).

This project sets the initial stack pointer to the end of RAM:

```ld
_estack = ORIGIN(RAM) + LENGTH(RAM);
```

The vector table’s first entry should contain `_estack`.

---

## 8. Verifying Placement (Map File + Objdump)

### A) Generate and inspect the linker map

Ensure the build produces a `.map` file (linker output).

Open:

```bash
less build/minimal.map
```

Confirm:

- `.text` and `.rodata` addresses start with `0x0800...` (FLASH)
- `.data` address starts with `0x2000...` (RAM) AND shows a "load address" `0x0800...` (FLASH)
- `.bss` address starts with `0x2000...` (RAM)

### B) Section headers via objdump

```bash
arm-none-eabi-objdump -h build/minimal.elf
```

This prints section VMAs/LMAs and sizes. It is a quick consistency check.

---

## 9. Notes / Common Confusion

- FLASH is memory-mapped, so code/consts can be accessed directly without copying.
- `.data` is copied because it must be writable but needs non-zero initial values.
- `.bss` is zeroed because it must start at zero and has no stored image.
- If `.isr_vector` shows size 0 in the map file, no object file is contributing a vector table yet.
- The vector table must be explicitly placed into `.isr_vector` via section attributes/directives.
