# baremetal-stm32

Bare-metal firmware development for STM32, built from first principles with explicit control over boot, memory, interrupts, and peripherals.

This repository focuses on understanding and owning the complete firmware bring-up path rather than relying on vendor frameworks or abstraction layers.

---

## Scope

This project intentionally covers the following areas:

- Bare-metal firmware development on STM32 (starting with STM32F411RE)
- Toolchain setup and reproducible builds (GCC, Make, OpenOCD, GDB)
- Custom linker scripts and startup code
- Explicit initialization of `.data` and `.bss`
- Interrupt handling and timing fundamentals
- Minimal, self-written peripheral drivers (GPIO, UART, timers, DMA)
- Hardware-validated behavior and measurement (not simulation-only)
- Clear, layered code organization suitable for later RTOS or SoC integration

The goal is to produce firmware that is understandable, debuggable, and defensible at every layer.

---

## Non-Goals

This project explicitly avoids the following:

- STM32 HAL, LL, CMSIS-Driver, or vendor startup code
- “Framework” or board-support abstractions
- Feature-complete peripheral coverage
- Multi-board or multi-MCU portability
- Performance micro-optimizations without measurement
- Production-ready APIs or backward compatibility guarantees

If something is not required to understand how the system works, it is intentionally excluded.

---

## Design Principles

- **Clarity over convenience**  
  Code should be readable and explainable without external tooling or generators.

- **Minimal abstraction**  
  Abstractions exist only when they reduce repetition or improve correctness.

- **Hardware-first validation**  
  Behavior is verified on real hardware whenever possible.

- **Incremental bring-up**  
  Each layer is validated before building on top of it.

---

## Target Platform

- **Board:** NUCLEO-F411RE
- **MCU:** STM32F411RE (Cortex-M4F)

Board-specific details live under `boards/nucleo_f411re/`.

---

## Project Status

Work is tracked via a public GitHub Project board using an issues-only workflow.  
Each issue represents a concrete, verifiable engineering task with clear exit criteria.

If it’s on the board, it gets finished.
