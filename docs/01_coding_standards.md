# Coding Standards

This document defines coding standards for the `baremetal-stm32` project.
The goal is consistency, readability, and debuggability — not stylistic perfection.

---

## Language Use

- **Primary language:** C (C11)
- **Assembly:** Used only where required (startup, vector table, low-level hooks)
- **C++:** Not used initially; may be introduced later with explicit rationale

---

## General Principles

- Code should be readable without IDE assistance
- Favor explicit code over clever code
- Avoid premature abstraction
- Prefer small, well-scoped functions
- Undefined behavior is unacceptable

---

## File Organization

- Board-specific code lives under:

  `boards/<board-name>/`

- Core, reusable code lives under:

  `lib/core/`

  `lib/drivers/`

- Applications live under:

  `apps/<app-name>/`

---

## Naming Conventions

### Files

- Lowercase with underscores

  i.e. `gpio.c`, `uart.h`, `systick.c`

### Functions

- Lowercase with underscores

  i.e. `uart_init()`, `gpio_set()`, `timer_start()`

### Types

- `snake_case_t` for typedefs

  i.e. `ringbuf_t`, `gpio_cfg_t`

### Macros

- Uppercase with underscore

  i.e. `GPIO_MODE_OUTPUT`, `ASSERT()`

## Formatting

- Indentation: **4 spaces**
- No tabs
- Braces on same line for functions and control blocks
- One statement per line

Example:

```c
if (status != OK) {
  panic();
}
```

## Register Access

- All MMIO access must go through centralized helpers where provided
- Avoid raw `volatile` pointer casts scattered throughout code
- Bit manipulation should be explicit and reusable

## Error Handling

- Fatal errors must route through `panic()`
- Silent failure is not acceptable
- Assertions may be used for internal invariants

## Comments

- Comment **why**, not what
- Avoid redundant comments
- Use comments to document assumptions and constraints

Bad:

```c
i++; // increment i
```

Good:

```c
i++; // advance to nest descriptor
```

## Warnings

- Code should compile cleanly with warnings enabled
- Warnings should not be ignored or suppressed without justification
