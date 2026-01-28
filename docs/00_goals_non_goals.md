# Project Goals and Non-Goals

This document defines the intent and boundaries of the `baremetal-stm32` project.
It exists to prevent scope drift and to make design tradeoffs explicit.

---

## Goals

The primary goals of this project are:

- Build a **bare-metal STM32 firmware stack from first principles**
- Own the complete bring-up path:
  - Toolchain and build
  - Linker script and startup code
  - Memory initialization (`.data`, `.bss`)
  - Interrupts and timing
  - Peripheral drivers (GPIO, UART, timers, DMA)
- Favor **clarity, correctness, and debuggability** over convenience
- Validate behavior on **real hardware**
- Organize code in a way that can later support:
  - RTOS integration
  - SoC-style HW/SW interaction
  - FPGA-attached peripherals

The project prioritizes _understanding how the system works_ over speed of implementation.

---

## Non-Goals

This project explicitly does **not** aim to:

- Use STM32 HAL, LL, CMSIS-Driver, or vendor startup code
- Be portable across multiple MCUs or boards
- Provide production-ready or feature-complete drivers
- Abstract hardware behind generic frameworks
- Optimize aggressively without measurement
- Replace vendor documentation or datasheets
- Support dynamic loading, rich libc features, or full POSIX behavior

If a feature does not directly contribute to understanding the system fundamentals,
it is intentionally excluded.

---

## Philosophy

- **Incremental bring-up**  
  Each layer is validated before building on top of it.

- **Minimal abstraction**  
  Abstractions are introduced only when they reduce repetition or improve correctness.

- **Explicit over implicit**  
  Configuration and behavior should be visible in code and documentation.

These constraints are intentional and should be treated as design requirements.
